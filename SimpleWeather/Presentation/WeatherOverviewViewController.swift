//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import UIKit

final class WeatherOverviewViewController: UIViewController {
    let viewModel: WeatherOverviewViewModel
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Cupertino"
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "22°"
        label.font = UIFont.systemFont(ofSize: 80, weight: .thin)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunny"
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: WeatherOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension WeatherOverviewViewController: UpdateWeatherDelegate {
    func updateWeather(model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.locationLabel.fadeTransition(0.2)
            self.temperatureLabel.fadeTransition(0.2)
            self.conditionLabel.fadeTransition(0.2)
            self.locationLabel.text = model.location
            self.temperatureLabel.text = "\(model.temperature)"
            self.conditionLabel.text = model.condition
        }
    }
}

private extension WeatherOverviewViewController {
    private func setupUI() {
        view.addSubview(locationLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(conditionLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            conditionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
