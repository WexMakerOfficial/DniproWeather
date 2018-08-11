//
//  DatabaseManager.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 8/5/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    //MARK: private let
    private let realmQueue = DispatchQueue(label: "realm queue")
    
    //MARK: init
    init() {
    }
    
    //MARK: funcs
    func update(_ forecast: [Weather], by type: ForecastType) {
        
        realmQueue.sync {
            
            do {
                let realm = try Realm()
                let oldObjects = realm.objects(Weather.self).filter("type = \(type.hashValue)")
                try realm.write {
                    realm.delete(oldObjects)
                    realm.add(forecast)
                }
            } catch let error{
                print(error)
            }
            
        }
        
    }
    
    func getForecast(by type: ForecastType, completion: @escaping ([Weather]) -> ()) {
        
        realmQueue.sync {
            
            do {
                let realm = try Realm()
                let objects = realm.objects(Weather.self).filter("type = \(type.hashValue)")
                var tempForecast: [Weather] = []
                objects.forEach {
                    tempForecast.append($0)
                }
                completion(tempForecast)
            } catch let error{
                print(error)
                completion([])
            }
            
        }
        
    }
}
