//
//  WeatherCVCellViewModel.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/17/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RxSwift

class WeatherCVCellViewModel {
    
    var dateTime    = PublishSubject<String>()
    var averageTemp = PublishSubject<String>()
    var minMaxTemp  = PublishSubject<String>()
    var windSpeed   = PublishSubject<String>()
    var humidity    = PublishSubject<String>()
    
    private let dispouseBag = DisposeBag()
    
    init(_ weather: Weather, type: ForecastType) {
        let dateFormater = DateFormatter()
        switch type {
        case .days:
            dateFormater.dateFormat = "DD.MM"
            break
        case .hours:
            dateFormater.dateFormat = "HH"
            break
        }
        let date = Date(timeIntervalSince1970: Double(weather.dateTimeUnix) ?? Date().timeIntervalSince1970)
        dateTime.onNext(dateFormater.string(from: date))
        averageTemp.onNext("\(weather.temp) ºC")
        minMaxTemp.onNext("\(weather.tempMin) ~ \(weather.tempMax) ºC")
        humidity.onNext("\(weather.humidity)%")
    }
    
}
