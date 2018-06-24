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
import Charts

class MainViewModel {
    
    private var weatherManager = WeatherManager()
    var cellArray = BehaviorRelay<[WeatherCVCellViewModel]>(value: [])
    private var forecast : BehaviorRelay<[Weather]> = BehaviorRelay(value: [])
    var forecastType = BehaviorRelay<ForecastType>(value: .days)
    var chartDataSet = BehaviorRelay<LineChartDataSet>(value: LineChartDataSet(values: [], label: "temp"))
    var moveTo = BehaviorRelay<Int>(value: 0)
    
    let disposeBag = DisposeBag()
    
    init() {
        self.forecast
            .distinctUntilChanged()
            .subscribe { [weak self] (tempForecast) in
                guard let realForecast = tempForecast.element, let strongSelf = self else { return }
                strongSelf.cellArray.accept(strongSelf.getCells(with: realForecast, type: strongSelf.forecastType.value))
                strongSelf.chartDataSet.accept(strongSelf.getChartDataSet(with: realForecast))
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
    
    func selectEntry (_ entry: ChartDataEntry) {
        moveTo.accept(chartDataSet.value.entryIndex(entry: entry) * 100)
    }
    
    //MARK: private func
    private func getCells(with weathers: [Weather], type: ForecastType) -> [WeatherCVCellViewModel] {
        var forecast = [WeatherCVCellViewModel]()
        for weather in weathers {
            forecast.append(WeatherCVCellViewModel(weather, type: type))
        }
        return forecast
    }
    
    private func getChartDataSet (with weathers: [Weather]) -> LineChartDataSet {
        var entrys = [ChartDataEntry]()
        var x : Double = 0
        for weather in weathers {
            x += 50
            entrys.append(ChartDataEntry(x: x, y: Double(weather.temp)))
        }
        let dataset = LineChartDataSet(values: entrys, label: "temp")
        return dataset
    }
    
}
