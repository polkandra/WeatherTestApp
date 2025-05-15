//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 14.05.2025.
//

import UIKit

final class WeatherOverviewViewController: UIViewController {
    let viewModel: WeatherOverviewViewModel
    private var hourForecastCollectionView: UICollectionView!
    private let items = ["Ячейка 1", "Ячейка 2", "Ячейка 3", "Ячейка 4", "Ячейка 5"]
    
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
        
        DispatchQueue.main.async {
            self.hourForecastCollectionView.reloadData()
        }
    }
}

private extension WeatherOverviewViewController {
    private func setupUI() {
        setupBaseForecastElements()
        setupHourForecastCollectionView()
    }
    
    private func setupBaseForecastElements() {
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
    
    private func setupHourForecastCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        
        hourForecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hourForecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourForecastCollectionView.backgroundColor = .green
        hourForecastCollectionView.layer.cornerRadius = 8
        
        hourForecastCollectionView.dataSource = self
        hourForecastCollectionView.delegate = self
        
        hourForecastCollectionView.register(HourForecastCollectionViewCell.self, forCellWithReuseIdentifier: HourForecastCollectionViewCell.identifier)
        
        view.addSubview(hourForecastCollectionView)
        
        NSLayoutConstraint.activate([
            hourForecastCollectionView.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 50),
            hourForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hourForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hourForecastCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WeatherOverviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hoursDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourForecastCollectionViewCell.identifier,
            for: indexPath
        ) as? HourForecastCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.configure(model: viewModel.hoursDataSource[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let width = (collectionView.frame.width - 20) / 2
        return CGSize(width: width, height: 100)
    }
}
