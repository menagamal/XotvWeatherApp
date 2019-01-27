//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewModel {
    
    var weather:Weather!
    
    var vc: UIViewController!
    
    var view:WeatherView!

    public enum Action {
        case  wait, idel, onError(str: String), getCityWeather(weather:Weather)
    }
    
    init( view:WeatherView,vc: UIViewController) {
        self.view = view
        self.vc = vc
        self.weather = Weather(viewModel: self)
        
    }
    
    func update(action: Action) {
        
        switch action {
        case .wait:
            view.update(action: .wait)
            break
        case .idel:
            view.update(action: .idel)
            break
        case .onError(let str):
            view.update(action: .onError(str: str))
            break
        case .getCityWeather(let weather):
            view.update(action: .getCityWeather(weather: weather))
            break
        }
        
    }
    
    func getCityWeather(lat:Double,lng:Double) {
        weather.getCityWeather(lat: lat, lng: lng)
    }
}
