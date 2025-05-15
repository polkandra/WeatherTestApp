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
        contentView.backgroundColor = .systemBlue
        createDayForecastStackView()
        setupIconImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: HourForecastWeatherModel) {
        hourLabel.text = "\(model.hour)"
        temperatureLabel.text = "\(model.temperature)"
        conditionImageView.setImage(from: "https:\(model.icon)", placeholder: UIImage(systemName: "scribble"))
    }
    
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
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = .white
        return label
    }()
}

private extension HourForecastCollectionViewCell {
    func createDayForecastStackView() {
        let stackView = UIStackView(arrangedSubviews: [hourLabel, conditionImageView, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.backgroundColor = .red
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    func setupIconImageConstraints() {
        NSLayoutConstraint.activate([
            conditionImageView.heightAnchor.constraint(equalToConstant: 50),
            conditionImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
