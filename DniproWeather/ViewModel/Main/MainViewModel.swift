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


protocol WeatherViewModelPrototype {
    var cellArray: BehaviorRelay<[WeatherCellViewModelPrototype]> { get }
    var forecastType: BehaviorRelay<ForecastType> { get }
    var chartDataSet: BehaviorRelay<LineChartDataSet> { get }
    var moveTo: BehaviorRelay<Int> { get }
    func selectEntry (_ entry: ChartDataEntry)
}

class MainViewModel: WeatherViewModelPrototype {

    //MARK: protocol var
    var cellArray = BehaviorRelay<[WeatherCellViewModelPrototype]>(value: [])
    var forecastType = BehaviorRelay<ForecastType>(value: .hours)
    var chartDataSet = BehaviorRelay<LineChartDataSet>(value: LineChartDataSet(values: [], label: "temp"))
    var moveTo = BehaviorRelay<Int>(value: 0)
    
    //MARK: private var
    private var weatherManager: WeatherManagerPrototype
    private var forecast : BehaviorRelay<[Weather]> = BehaviorRelay(value: [])
    
    //MARK: private let
    private let disposeBag = DisposeBag()
    
    //MARK: init
    init(_ manager: WeatherManagerPrototype) {
        weatherManager = manager
        bind()
    }
    
    //MARK: protocol funcs
    func selectEntry (_ entry: ChartDataEntry) {
        moveTo.accept(chartDataSet.value.entryIndex(entry: entry) * 100)
    }
    
    //MARK: private funcs
    private func bind() {
        forecast
            .distinctUntilChanged()
            .subscribe { [weak self] (tempForecast) in
                guard let realForecast = tempForecast.element, let strongSelf = self else { return }
                strongSelf.cellArray.accept(strongSelf.getCells(with: realForecast, type: strongSelf.forecastType.value))
                strongSelf.chartDataSet.accept(strongSelf.getChartDataSet(with: realForecast))
            }
            .disposed(by: disposeBag)
        
        forecastType
            .distinctUntilChanged()
            .subscribe { [weak self] (type) in
                guard let strongSelf = self else { return }
                guard let currentType = type.element else { return }
                strongSelf.weatherManager.getWeatherList(with: currentType, completion: { (forecast) in
                    strongSelf.forecast.accept(forecast)
                })
            }
            .disposed(by: disposeBag)
    }
    
    private func getCells(with weathers: [Weather], type: ForecastType) -> [WeatherCVCellViewModel] {
        var forecast = [WeatherCVCellViewModel]()
        for weather in weathers {
            forecast.append(WeatherCVCellViewModel(WeatherCellModel(weather: weather, type: type)))
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
