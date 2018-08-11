//
//  WeatherModel.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 8/11/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation

protocol WeatherPrototype {
    var weather: Weather { get }
    var type: ForecastType { get }
}

struct WeatherCellModel: WeatherPrototype {
    let weather: Weather
    let type: ForecastType
}
