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
    
    private let activityIndicator = WeatherStyleActivityIndicator(
        frame: CGRect(x: 0, y: 0, width: 50, height: 50)
    )
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dailyForecastView: DailyForecastView = {
        let forecastView = DailyForecastView()
        forecastView.translatesAutoresizingMaskIntoConstraints = false
        return forecastView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weatherPic")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 80, weight: .thin)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let forecastLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .regular)
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


// MARK: - UpdateWeatherDelegate

extension WeatherOverviewViewController: UpdateWeatherDelegate {
    func showErrorPopUp() {
        DispatchQueue.main.async {
            self.showWeatherErrorAlert(on: self)
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.center = contentView.center
        contentView.addSubview(activityIndicator)
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    func updateWeather(model: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.locationLabel.fadeTransition(0.2)
            self.temperatureLabel.fadeTransition(0.2)
            self.conditionLabel.fadeTransition(0.2)
            self.forecastLabel.fadeTransition(0.2)
            self.locationLabel.text = model.location
            self.temperatureLabel.text = "\(Int(model.temperature.rounded(.towardZero)))°"
            self.conditionLabel.text = model.condition
            self.forecastLabel.text = "Min: \(Int(model.minTemperature.rounded(.towardZero)))°, max: \(Int(model.maxTemperature.rounded(.towardZero)))°"
            
            self.hourForecastCollectionView.reloadData()
            self.dailyForecastView.updateForecasts(self.viewModel.dailyDataSource)
        }
    }
}


// MARK: - Private methods

private extension WeatherOverviewViewController {
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .systemBlue
        setupBaseForecastElements()
        setupHourForecastCollectionView()
        setupCurrentWeatherView()
    }
    
    private func setupBaseForecastElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(forecastLabel)
        contentView.addSubview(dailyForecastView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 50),
            locationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
          
            temperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
           
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            conditionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
           
            forecastLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor),
            forecastLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupHourForecastCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 8
        
        hourForecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hourForecastCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        hourForecastCollectionView.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        hourForecastCollectionView.layer.cornerRadius = 8
        hourForecastCollectionView.showsHorizontalScrollIndicator = false
        hourForecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        hourForecastCollectionView.dataSource = self
        hourForecastCollectionView.delegate = self
        
        hourForecastCollectionView.register(
            HourForecastCollectionViewCell.self,
            forCellWithReuseIdentifier: HourForecastCollectionViewCell.identifier
        )
        
        contentView.addSubview(hourForecastCollectionView)
        
        NSLayoutConstraint.activate([
            hourForecastCollectionView.topAnchor.constraint(equalTo: forecastLabel.bottomAnchor, constant: 50),
            hourForecastCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hourForecastCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hourForecastCollectionView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    private func setupCurrentWeatherView() {
        contentView.addSubview(dailyForecastView)
        
        NSLayoutConstraint.activate([
            dailyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dailyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dailyForecastView.topAnchor.constraint(equalTo: hourForecastCollectionView.bottomAnchor, constant: 10),
            dailyForecastView.heightAnchor.constraint(equalToConstant: 315)
        ])
    }
    
    func showWeatherErrorAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: """
                    Не удалось получить данные о погоде. 
                    Проверьте подключение к интернету и попробуйте снова.
                    """,
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(
            title: "Повторить",
            style: .default
        ) { [weak self] _ in
            
            guard let self else {
                return
            }
            
            self.viewModel.retryFetchingWeather()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
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
        
        return CGSize(width: 50, height: 100)
    }
}
