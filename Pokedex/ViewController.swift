//
//  ViewController.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 14/03/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    let pokedexView = PokedexView()
    var classifier: Classification!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = pokedexView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokedexView.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        addClassifier()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCameraConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    //MARK: - Functions
    
    @objc func didTapButton() {
        capturePhoto()
        let gif = UIImage.gifImageWithName("charmanderGif")
        pokedexView.loaderImage.image = gif
        pokedexView.loaderImage.isHidden = false
        pokedexView.captureImage.isHidden = true
        pokedexView.resultLabel.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            self.pokedexView.loaderImage.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.pokedexView.captureImage.isHidden = false
                self.pokedexView.resultLabel.isHidden = false
            }
        }
    }
    
    private func addClassifier() {
        classifier = Classification(delegate: self)
    }
    
    private func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func updateImage(image: UIImage) {
        self.pokedexView.captureImage.image = image
        evaluateImage(image)
    }
    
    private func evaluateImage(_ image: UIImage) {
        classifier.updateClassifications(for: image)
    }
    
}

//MARK: - CameraConfiguration

extension ViewController {
    
    private func addCameraConfig() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Sin permisos para la cámara!")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error con la cámara:  \(error.localizedDescription)")
        }
    }
    
    private func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill // Usar .resizeAspectFill para llenar el área de enfoque
        videoPreviewLayer.connection?.videoOrientation = .portrait
        pokedexView.cameraView.layer.addSublayer(videoPreviewLayer)
        // Iniciar la sesión de captura en una cola de fondo para evitar bloquear el hilo principal
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            // Una vez que la sesión está en marcha, configurar el frame de la capa de previsualización en el hilo principal
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.videoPreviewLayer.frame = weakSelf.pokedexView.cameraView.bounds
                // Si necesitas que la capa de previsualización tenga un tamaño específico, como 320x320,
                // y que esté centrada, puedes ajustar el frame aquí.
                // Por ejemplo:
                let layerSize = CGSize(width: 320, height: 320)
                weakSelf.videoPreviewLayer.frame = CGRect(
                    x: (weakSelf.pokedexView.cameraView.bounds.width - layerSize.width) / 2,
                    y: (weakSelf.pokedexView.cameraView.bounds.height - layerSize.height) / 2,
                    width: layerSize.width,
                    height: layerSize.height
                )
            }
        }
    }
    
}

//MARK: - ClassificationDelegate

extension ViewController: ClassificationDelegate {
    
    func didFinishClassification(withResult result: Result<(String, Float), any Error>) {
        switch result {
        case .success(let classification):
            if classification.1 > 0.60 {
                print("Clasificación lista \(classification.0) \(classification.1)")
                pokedexView.resultLabel.text = "Es \(classification.0) reconocido con una seguridad del \(classification.1 * 100)%"
            } else {
                pokedexView.resultLabel.text = "No pude reconocer a ese pokemon 🫠."
            }
        case .failure(let error):
            print("Falló la clasificación: \(error.localizedDescription)")
            pokedexView.resultLabel.text = "Error: \(error.localizedDescription)"
        }
    }
    
}

//MARK: - AVCapturePhotoCaptureDelegate

extension ViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let capturedImage = UIImage(data: data),
              let squareImage = capturedImage.cropToSquare() else {
            print("Error procesando la foto")
            return
        }
        let resizedImage = squareImage.scaleImage(toSize: CGSize(width: 320, height: 320))
        DispatchQueue.main.async { [weak self] in
            self?.updateImage(image: resizedImage)
        }
    }
    
}
