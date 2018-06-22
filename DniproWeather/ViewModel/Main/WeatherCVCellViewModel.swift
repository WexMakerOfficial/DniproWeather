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
    
    var dateTime    = BehaviorSubject<String>(value: "")
    var averageTemp = BehaviorSubject<String>(value: "")
    var minMaxTemp  = BehaviorSubject<String>(value: "")
    var windSpeed   = BehaviorSubject<String>(value: "")
    var humidity    = BehaviorSubject<String>(value: "")
    
    private let dispouseBag = DisposeBag()
    
    init(_ weather: Weather, type: ForecastType) {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(secondsFromGMT: 3)
        switch type {
        case .days:
            dateFormater.dateStyle = .short
            dateFormater.timeStyle = .none
            break
        case .hours:
            dateFormater.dateStyle = .none
            dateFormater.timeStyle = .short
            break
        }
        let date = Date(timeIntervalSince1970: Double(weather.dateTimeUnix) ?? Date().timeIntervalSince1970)
        dateTime.onNext(dateFormater.string(from: date))
        averageTemp.onNext("\(weather.temp) ºC")
        minMaxTemp.onNext("\(weather.tempMin) ~ \(weather.tempMax) ºC")
        windSpeed.onNext("\(weather.windSpeed) m/s")
        humidity.onNext("\(weather.humidity)%")
    }
    
}
