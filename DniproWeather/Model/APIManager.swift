//
//  APIManager.swift
//  DniproWeather
//
//  Created by Sergey Prikhodko on 6/24/18.
//  Copyright © 2018 Sergey Prikhodko. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class APIManager {
    
    private let disposeBag = DisposeBag()
    
    private enum Route {
        
        case getDayForecast
        case getWeekForecast
        
        var urlRequest : URLRequest {
            return URLRequest(url: url)
        }
        
        private var url : URL {
            switch self {
            case .getDayForecast:
                return URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=709930&cnt=8&units=metric&APPID=2545520a04f1aa39be516f1b6473bb24")!
            case .getWeekForecast:
                return URL(string: "https://api.apixu.com/v1/forecast.json?key=e0880be78824475b94972404181706&q=Dnipropetrovsk&days=7")!
            }
        }
        
        static func currentType (_ type: ForecastType) -> Route {
            switch type {
            case .hours:
                return self.getDayForecast
            case .days:
                return self.getWeekForecast
            }
        }
    }
    
    func getForecast (_ type: ForecastType, completion: @escaping (_ json: JSON) -> ()) {
        let route = Route.currentType(type)
        _ = URLSession.shared.rx
            .data(request: route.urlRequest)
            .distinctUntilChanged()
            .subscribe {
                guard let element = $0.element else { return }
                guard let json = try? JSON(data: element) else { return }
                completion(json)
            }
    }
    
}
