//
//  WeatherManager.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/17/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class WeatherManager {
    
    private var realm: Realm?
    private var apiManager = APIManager()
    
    init() {
        self.realm = try? Realm()
    }
    
    //MARK: public funcs
    func getWeatherListFromAPI (with type: ForecastType ,completeion: @escaping (_ forecast: [Weather]) -> Void) {
        apiManager.getForecast(type) { [weak self] (json) in
            guard let strongSelf = self else { return }
            print(json)
            switch type {
            case .hours:
                completeion(strongSelf.getDayForecast(json))
            case .days:
                completeion(strongSelf.getWeekForecast(json))
            }
        }
    }
    
    func getWeatherFromDB () -> [Weather] {
        if let array = realm?.objects(Weather.self) {
            return array.reversed()
        } else {
            return []
        }
    }
    
    //MARK: private funcs
    private func getFromApi (_ type: ForecastType) -> [Weather] {
        return []
    }
    
    private func getDayForecast(_ json: JSON) -> [Weather] {
        var weathers = [Weather]()
        guard let weatherList = json["list"].array else { return [] }
        for weather in weatherList {
            let main = weather["main"]
            let currentWeather = Weather()
            if let tempMin = main["temp_min"].int {
                currentWeather.tempMin = tempMin
            }
            if let tempMax = main["temp_max"].int {
                currentWeather.tempMax = tempMax
            }
            if let temp = main["temp"].int {
                currentWeather.temp = temp
            }
            if let humidity = main["humidity"].float {
                currentWeather.humidity = humidity
            }
            let wind = weather["wind"]
            if let speed = wind["speed"].int {
                currentWeather.windSpeed = speed
            }
            if let unixTime = weather["dt"].double {
                currentWeather.dateTimeUnix = unixTime
            }
            weathers.append(currentWeather)
        }
        return weathers
    }
    
    private func getWeekForecast(_ json: JSON) -> [Weather] {
        var weathers = [Weather]()
        guard let weatherList = json["forecast"]["forecastday"].array else {
            return []
        }
        for weather in weatherList {
            let currentWeather = Weather()
            if let unixTime = weather["date_epoch"].double {
                currentWeather.dateTimeUnix = unixTime
            }
            let day = weather["day"]
            if let minTemp = day["mintemp_c"].int {
                currentWeather.tempMin = minTemp
            }
            if let maxTemp = day["maxtemp_c"].int {
                currentWeather.tempMax = maxTemp
            }
            if let temp = day["avgtemp_c"].int {
                currentWeather.temp = temp
            }
            if let humidity = day["avghumidity"].float {
                currentWeather.humidity = humidity
            }
            if let windSpeed = day["maxwind_kph"].double {
                currentWeather.windSpeed = Int(windSpeed / 3.6)
            }
            weathers.append(currentWeather)
        }
        return weathers
    }
}
