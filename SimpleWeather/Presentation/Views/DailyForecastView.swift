//
//  DailyForecastView.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 21.05.2025.
//

import UIKit

final class DailyForecastView: UIView {
    
    private let stackView = UIStackView()
    private var forecastRows: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue.withAlphaComponent(0.5)
        layer.cornerRadius = 8
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    func updateForecasts(_ forecasts: [DailyForecastWeatherModel]) {
        fadeOutOldForecasts {
            self.forecastRows.forEach {
                self.stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            
            self.forecastRows.removeAll()
            self.fadeInNewForecasts(forecasts)
        }
    }
}

private extension DailyForecastView {
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func fadeOutOldForecasts(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.forecastRows.forEach {
                    $0.alpha = 0
                }
            },
            completion: { _ in
                completion()
            }
        )
    }
    
    private func fadeInNewForecasts(_ forecasts: [DailyForecastWeatherModel]) {
        for forecast in forecasts {
            let row = createRow(for: forecast)
            row.alpha = 0
            self.forecastRows.append(row)
            self.stackView.addArrangedSubview(row)
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.forecastRows.forEach {
                    $0.alpha = 1
                }
            }
        )
    }
    
    private func createRow(for forecast: DailyForecastWeatherModel) -> UIView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.distribution = .fillEqually
        rowStack.alignment = .center
        rowStack.spacing = 6
        
        let dayLabel = UILabel()
        dayLabel.text = forecast.day
        dayLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        dayLabel.textColor = .white
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        iconView.setImage(
            from: "https:\(forecast.icon)",
            placeholder: UIImage(systemName: "scribble")
        )
        
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let highTempLabel = UILabel()
        highTempLabel.text = "\(Int(Double(forecast.highTemp)?.rounded(.towardZero) ?? 0))°"
        highTempLabel.textColor = .white
        highTempLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let lowTempLabel = UILabel()
        lowTempLabel.text = "\(Int(Double(forecast.lowTemp)?.rounded(.towardZero) ?? 0))°"
        lowTempLabel.textColor = .white
        lowTempLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        let tempStack = UIStackView(arrangedSubviews: [lowTempLabel, highTempLabel])
        tempStack.axis = .horizontal
        rowStack.distribution = .fillEqually
        rowStack.alignment = .center
        tempStack.spacing = 6
        
        rowStack.addArrangedSubview(dayLabel)
        rowStack.addArrangedSubview(iconView)
        rowStack.addArrangedSubview(tempStack)
        
        return rowStack
    }
}
