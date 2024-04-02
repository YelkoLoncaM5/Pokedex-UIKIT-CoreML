//
//  DetailPokemonViewController.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 1/04/24.
//

import UIKit
import Kingfisher

final class DetailPokemonViewController: UIViewController {
    
    // MARK: - Views
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = .zero
        label.textColor = .black
        label.textAlignment = .justified
        return label
    }()
    
    private let titleStatsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Stats"
        return label
    }()
    
    // MARK: - Properties
    
    var pokemon: Pokemon?
    var color: UIColor?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
        loadData()
        setupViews()
    }
    
    // MARK: - Functions
    
    private func loadData() {
        if let urlString = pokemon?.imageUrl, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
        titleLabel.text = pokemon?.name.capitalized
        typeLabel.text = pokemon?.type.capitalized
        descriptionLabel.text = pokemon?.description
        typeLabel.backgroundColor = color
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(descriptionView)
        descriptionView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(titleStatsLabel)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: descriptionView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: 100),
            typeLabel.heightAnchor.constraint(equalToConstant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -15),
            titleStatsLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 15),
            titleStatsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -15),
        ])
        setupCornerRadius()
        setupStatsView()
    }
    
    private func setupStatsView() {
        guard let pokemon = pokemon else { return }
        let statViews: [(stat: Int, type: StatType)] = [
            (pokemon.height, .height),
            (pokemon.weight, .weight),
            (pokemon.attack, .attack),
            (pokemon.defense, .defense)
        ]
        for (stat, type) in statViews {
            let statView = StatView(amountStat: stat, statType: type)
            stackView.addArrangedSubview(statView)
            statView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                statView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 30),
                statView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -30),
            ])
        }
    }
    
    private func setupCornerRadius() {
        descriptionView.layer.cornerRadius = 30
        descriptionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        descriptionView.clipsToBounds = true
    }
    
}

extension DetailPokemonViewController {
    
    class StatView: UIView {
        
        // MARK: - Views
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.alignment = .center
            stackView.distribution = .fill
            return stackView
        }()
        
        private let statTitleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.text = "Defense"
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let statAmountLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.text = "23"
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let progressBar: UIProgressView = {
            let progress = UIProgressView()
            progress.progress = 0.5
            progress.layer.cornerRadius = 8
            progress.clipsToBounds = true
            return progress
        }()
        
        // MARK: - Lifecycle
        
        init(amountStat: Int, statType: StatType) {
            super.init(frame: .zero)
            loadData(amountStat: amountStat, statType: statType)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        // MARK: - Functions
        
        private func loadData(amountStat: Int, statType: StatType) {
            statTitleLabel.text = statType.rawValue
            statAmountLabel.text = "\(amountStat)"
            progressBar.progressTintColor = statType.color
            progressBar.setProgress(Float(amountStat) / Float(100), animated: true)
        }
        
        private func setupView() {
            addSubview(stackView)
            stackView.addArrangedSubview(statTitleLabel)
            stackView.addArrangedSubview(statAmountLabel)
            stackView.addArrangedSubview(progressBar)
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                statAmountLabel.widthAnchor.constraint(equalToConstant: 50),
                statTitleLabel.widthAnchor.constraint(equalToConstant: 80),
                progressBar.heightAnchor.constraint(equalToConstant: 16)
            ])
        }
        
    }
    
}

// MARK: - StatType

enum StatType: String {
    
    case height = "Height"
    case weight = "Weight"
    case attack = "Attack"
    case defense = "Defense"
    
    var color: UIColor {
        switch self {
        case .height:
            return .systemOrange
        case .weight:
            return .systemPurple
        case .attack:
            return .systemRed
        case .defense:
            return .systemBlue
        }
    }
    
}
