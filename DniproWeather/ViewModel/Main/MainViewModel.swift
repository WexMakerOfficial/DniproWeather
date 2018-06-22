//
//  MainViewModel.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/18/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    
    private var weatherManager = WeatherManager()
    var cellArray = BehaviorRelay<[WeatherCVCellViewModel]>(value: [])
    private var forecast : BehaviorRelay<[Weather]> = BehaviorRelay(value: [])
    var forecastType = BehaviorRelay<ForecastType>(value: .days)
    var chartPoints = BehaviorRelay<[Double]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init() {
        self.forecast
            .distinctUntilChanged()
            .subscribe { [weak self] (tempForecast) in
                guard let realForecast = tempForecast.element, let strongSelf = self else { return }
                strongSelf.cellArray.accept(strongSelf.getCells(with: realForecast, type: strongSelf.forecastType.value))
                strongSelf.chartPoints.accept(strongSelf.getChartPoints(with: realForecast))
            }
            .disposed(by: disposeBag)
    
        self.weatherManager.getWeatherListFromAPI(with: self.forecastType.value) { [weak self] (forecast) in
            guard let strongSelf = self else { return }
            strongSelf.forecast.accept(forecast)
        }
        
        self.forecastType
            .distinctUntilChanged()
            .subscribe { [weak self] (type) in
                guard let strongSelf = self else { return }
                guard let currentType = type.element else { return }
                strongSelf.weatherManager.getWeatherListFromAPI(with: currentType, completeion: { (forecast) in
                    strongSelf.forecast.accept(forecast)
                })
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: private func
    private func getCells(with weathers: [Weather], type: ForecastType) -> [WeatherCVCellViewModel] {
        var forecast = [WeatherCVCellViewModel]()
        for weather in weathers {
            forecast.append(WeatherCVCellViewModel(weather, type: type))
        }
        return forecast
    }
    
    private func getChartPoints (with weathers: [Weather]) -> [Double] {
        var points = [Double]()
        for weather in weathers {
            points.append(Double(weather.temp))
        }
        return points
    }
    
}
