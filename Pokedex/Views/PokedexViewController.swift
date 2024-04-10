//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 14/03/24.
//

import UIKit
import AVFoundation

final class PokedexViewController: UIViewController {
    
    //MARK: - Properties
    
    let pokedexView = PokedexView()
    var viewModel = PokemonViewModel()
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
        pokedexView.resultLabel.text = "Esperando..."
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
    
    private func showPokemonDetail(named pokemonName: String) {
        guard let pokemon = viewModel.findPokemon(byName: pokemonName) else {
            print("No se encontró el Pokémon con el nombre: \(pokemonName)")
            return
        }
        let detailVC = DetailPokemonViewController()
        detailVC.pokemon = pokemon
        detailVC.color = viewModel.backgroundColor(forType: pokemon.type)
        navigationController?.present(detailVC, animated: true)
    }
    
}

//MARK: - CameraConfiguration

extension PokedexViewController {
    
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
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        pokedexView.cameraView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.pokedexView.cameraView.bounds
                let layerSize = CGSize(width: 320, height: 320)
                self.videoPreviewLayer.frame = CGRect(
                    x: (self.pokedexView.cameraView.bounds.width - layerSize.width) / 2,
                    y: (self.pokedexView.cameraView.bounds.height - layerSize.height) / 2,
                    width: layerSize.width,
                    height: layerSize.height
                )
            }
        }
    }
    
}

//MARK: - ClassificationDelegate

extension PokedexViewController: ClassificationDelegate {
    
    func didFinishClassification(withResult result: Result<(String, Float), any Error>) {
        switch result {
        case .success(let classification):
            if classification.1 > 0.60 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    guard let self else { return }
                    self.pokedexView.resultLabel.text = "Es \(classification.0) - Seguridad del \(classification.1 * 100)%"
                    self.navigationItem.title = "\(classification.0.uppercased())"
                    self.navigationController?.navigationBar.backgroundColor = .systemGreen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showPokemonDetail(named: classification.0)
                    }
                }
            } else {
                pokedexView.resultLabel.text = "No pude reconocer a ese pokemon 🫠."
            }
        case .failure(let error):
            pokedexView.resultLabel.text = "Error: \(error.localizedDescription)"
        }
    }
    
}

//MARK: - AVCapturePhotoCaptureDelegate

extension PokedexViewController: AVCapturePhotoCaptureDelegate {
    
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
