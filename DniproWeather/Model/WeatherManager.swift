//
//  WeatherManager.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/17/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherManager {
    
    private var realm: Realm?
    
    init() {
        self.realm = try? Realm()
    }
    
    //MARK: public funcs
    func getWeatherListFromAPI (with type: ForecastType ,completeion: (_ forecast: [Weather]) -> Void) {
        var weathers = [Weather]()
        switch type {
        case .days:
            for _ in 0..<5 {
                let weather = Weather()
                weather.temp = Int(arc4random_uniform(40))
                weathers.append(weather)
            }
        case .hours:
            for _ in 0..<3 {
                let weather = Weather()
                weather.temp = Int(arc4random_uniform(40))
                weathers.append(weather)
            }
        }
        completeion(weathers)
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
}
