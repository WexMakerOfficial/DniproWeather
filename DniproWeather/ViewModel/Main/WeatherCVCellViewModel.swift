//
//  WeatherCVCellViewModel.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/17/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherCellViewModelPrototype {
    var dateTime: BehaviorSubject<String> { get }
    var averageTemp: BehaviorSubject<String> { get }
    var minMaxTemp: BehaviorSubject<String> { get }
    var windSpeed: BehaviorSubject<String> { get }
    var humidity: BehaviorSubject<String> { get }
}

class WeatherCVCellViewModel: WeatherCellViewModelPrototype {
    
    var dateTime    = BehaviorSubject<String>(value: "")
    var averageTemp = BehaviorSubject<String>(value: "")
    var minMaxTemp  = BehaviorSubject<String>(value: "")
    var windSpeed   = BehaviorSubject<String>(value: "")
    var humidity    = BehaviorSubject<String>(value: "")
    
    private let dispouseBag = DisposeBag()
    
    init(_ model: WeatherPrototype) {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(secondsFromGMT: 10800)
        switch model.type {
        case .days:
            dateFormater.dateStyle = .short
            dateFormater.timeStyle = .none
            break
        case .hours:
            dateFormater.dateStyle = .none
            dateFormater.timeStyle = .short
            break
        }
        let date = Date(timeIntervalSince1970: model.weather.dateTimeUnix)
        dateTime.onNext(dateFormater.string(from: date))
        averageTemp.onNext("\(model.weather.temp) ºC")
        minMaxTemp.onNext("\(model.weather.tempMin) ~ \(model.weather.tempMax) ºC")
        windSpeed.onNext("\(model.weather.windSpeed) m/s")
        humidity.onNext("\(model.weather.humidity)%")
    }
    
}
