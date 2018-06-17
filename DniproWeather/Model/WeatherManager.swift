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
    func getWeatherList () -> [Weather] {
        var weathers = [Weather]()
        for _ in 0..<5 {
            weathers.append(Weather())
        }
        return weathers
    }
    //MARK: private funcs
    private func getWeatherFromDB () -> [Weather] {
        if let array = realm?.objects(Weather.self) {
            return array.reversed()
        } else {
            return []
        }
    }
    
    private func getFromApi (_ type: ForecastType) -> [Weather] {
        return []
    }
}
