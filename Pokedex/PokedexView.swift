//
//  PokedexView.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 14/03/24.
//

import UIKit

extension ViewController {
    
    final class PokedexView: UIView {
        
        // MARK: - Views
        
        private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()
        
        private let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(red: 0.92, green: 0.07, blue: 0.07, alpha: 0.8)
            return view
        }()
        
        private let titleStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fill
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Pokédex"
            label.textColor = .white
            label.font = .systemFont(ofSize: 30, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "pokeball.png")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private (set) var cameraView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            return view
        }()
        
        private (set) var button: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "boton.png"), for: .normal)
            return button
        }()
        
        private let resultView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let messageView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let leftImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Izquierdo.png")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private let rightImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Derecho.png")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        private let stackViewMessage: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private (set) var captureImage: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "estrella.png")
            imageView.isHidden = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private (set) var resultLabel: UILabel = {
            let label = UILabel()
            label.text = "Pikachu ha sido reconocido con un 99.0% de certeza."
            label.textColor = .black
            label.font = .systemFont(ofSize: 15, weight: .regular)
            label.numberOfLines = .zero
            label.isHidden = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private (set) var loaderImage: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            let gif = UIImage.gifImageWithName("pikachuGif")
            imageView.image = gif
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isHidden = false
            return imageView
        }()
        
        // MARK: - Lifecycle
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        // MARK: - Functions
        
        func setupView() {
            addSubview(scrollView)
            scrollView.addSubview(contentView)
            contentView.addSubview(titleStackView)
            contentView.addSubview(cameraView)
            contentView.addSubview(button)
            contentView.addSubview(resultView)
            titleStackView.addArrangedSubview(imageView)
            titleStackView.addArrangedSubview(titleLabel)
            resultView.addSubview(messageView)
            resultView.addSubview(leftImage)
            resultView.addSubview(rightImage)
            messageView.addSubview(stackViewMessage)
            stackViewMessage.addArrangedSubview(captureImage)
            stackViewMessage.addArrangedSubview(resultLabel)
            stackViewMessage.addArrangedSubview(loaderImage)
            NSLayoutConstraint.activate([
                //Superior
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                titleStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                cameraView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 75),
                cameraView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                button.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: 50),
                button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                //Resultado
                resultView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 50),
                resultView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                resultView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
                leftImage.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
                leftImage.topAnchor.constraint(equalTo: resultView.topAnchor),
                leftImage.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
                rightImage.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
                rightImage.topAnchor.constraint(equalTo: resultView.topAnchor),
                rightImage.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
                messageView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 40),
                messageView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -40),
                messageView.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -15),
                messageView.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 10),
                stackViewMessage.topAnchor.constraint(equalTo: messageView.topAnchor),
                stackViewMessage.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
                stackViewMessage.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 25),
                stackViewMessage.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -25),
                //Superior
                cameraView.widthAnchor.constraint(equalToConstant: 320),
                cameraView.heightAnchor.constraint(equalToConstant: 320),
                button.heightAnchor.constraint(equalToConstant: 60),
                button.widthAnchor.constraint(equalToConstant: 60),
                imageView.heightAnchor.constraint(equalToConstant: 30),
                imageView.widthAnchor.constraint(equalToConstant: 30),
                //Resultado
                resultView.widthAnchor.constraint(equalToConstant: 330),
                resultView.heightAnchor.constraint(equalToConstant: 140),
                leftImage.widthAnchor.constraint(equalToConstant: 60),
                rightImage.widthAnchor.constraint(equalToConstant: 60),
                captureImage.heightAnchor.constraint(equalToConstant: 50),
                captureImage.widthAnchor.constraint(equalToConstant: 50),
                loaderImage.heightAnchor.constraint(equalToConstant: 80),
            ])
            addBorder()
        }
        
        func addBorder() {
            cameraView.layer.borderWidth = 10
            cameraView.layer.borderColor = UIColor.white.cgColor
            cameraView.layer.cornerRadius = 20
            messageView.layer.borderWidth = 3
            messageView.layer.borderColor = UIColor.black.cgColor
        }
        
    }
    
}
