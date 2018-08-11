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
    
    //MARK: private var
    private var weatherManager = WeatherManager()
    private var forecast : BehaviorRelay<[Weather]> = BehaviorRelay(value: [])

    //MARK: var
    var cellArray = BehaviorRelay<[WeatherCVCellViewModel]>(value: [])
    var forecastType = BehaviorRelay<ForecastType>(value: .hours)
    var chartDataSet = BehaviorRelay<LineChartDataSet>(value: LineChartDataSet(values: [], label: "temp"))
    var moveTo = BehaviorRelay<Int>(value: 0)
    
    //MARK: let
    let disposeBag = DisposeBag()
    
    //MARK: init
    init() {
        
        self.forecast
            .distinctUntilChanged()
            .subscribe { [weak self] (tempForecast) in
                guard let realForecast = tempForecast.element, let strongSelf = self else { return }
                strongSelf.cellArray.accept(strongSelf.getCells(with: realForecast, type: strongSelf.forecastType.value))
                strongSelf.chartDataSet.accept(strongSelf.getChartDataSet(with: realForecast))
            }
            .disposed(by: disposeBag)
        
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
    
    //MARK: funcs
    func selectEntry (_ entry: ChartDataEntry) {
        moveTo.accept(chartDataSet.value.entryIndex(entry: entry) * 100)
    }
    
    //MARK: private funcs
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
