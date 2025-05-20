//
//  HourForecastCollectionViewCell.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 15.05.2025.
//

import UIKit

class HourForecastCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourForecastCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createDayForecastStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: HourForecastWeatherModel) {
        hourLabel.fadeTransition(0.2)
        temperatureLabel.fadeTransition(0.2)
        hourLabel.text = "\(model.hour)"
        temperatureLabel.text = "\(Int(model.temperature.rounded(.towardZero)))°"
        
        conditionImageView.setImage(
            from: "https:\(model.icon)",
            placeholder: UIImage(systemName: "scribble")
        )
    }
    
    private var stackView = UIStackView()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.text = "17"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "12°C"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        return label
    }()
}


// MARK: - Private methods

private extension HourForecastCollectionViewCell {
    func createDayForecastStackView() {
        stackView = UIStackView(arrangedSubviews: [hourLabel, conditionImageView, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
