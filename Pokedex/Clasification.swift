//
//  Clasification.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 18/03/24.
//

import UIKit
import CoreML
import Vision

protocol ClassificationDelegate: AnyObject {
    
    func didFinishClassification(withResult result: Result<(String, Float), Error>)
    
}

class Classification {
    
    weak var delegate: ClassificationDelegate?
    
    init(delegate: ClassificationDelegate) {
        self.delegate = delegate
    }
    
    private lazy var classificationRequest: VNCoreMLRequest? = {
        do {
            // Cargando el modelo de ML con un nuevo enfoque que maneja errores
            let modelConfiguration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: PokeClasificador1(configuration: modelConfiguration).model)
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            // Manejo adecuado de errores al cargar el modelo
            print("Error cargando el modelo: \(error)")
            self.delegate?.didFinishClassification(withResult: .failure(error))
            return nil
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let classificationRequest = self.classificationRequest else {
                print("VNCoreMLRequest not properly initialized.")
                return
            }
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: image.cgOrientation)
            do {
                try handler.perform([classificationRequest])
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFinishClassification(withResult: .failure(error))
                }
            }
        }
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results as? [VNClassificationObservation] else {
                self.delegate?.didFinishClassification(
                    withResult: .failure(error ?? NSError(
                        domain: "com.yourdomain.pokedexML",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to process the image."])
                    )
                )
                return
            }
            guard let topResult = results.first else {
                self.delegate?.didFinishClassification(
                    withResult: .failure(NSError(
                        domain: "com.yourdomain.pokedexML",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No classification was possible."])
                    )
                )
                return
            }
            let classificationResult = (topResult.identifier, topResult.confidence)
            self.delegate?.didFinishClassification(withResult: .success(classificationResult))
        }
    }
    
}
