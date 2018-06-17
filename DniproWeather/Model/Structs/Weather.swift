//
//  Weather.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/17/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    @objc dynamic var dateTimeUnix = "1529245812"
    @objc dynamic var temp = 0
    @objc dynamic var tempMax = 0
    @objc dynamic var tempMin = 0
    @objc dynamic var windSpeed = 0
    @objc dynamic var humidity: Float = 0
}
