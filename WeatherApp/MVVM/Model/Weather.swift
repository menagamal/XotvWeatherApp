//
//  Weather.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import Foundation


class Weather:BaseModel ,ApiManagerDelegate{
    
    var description:String!
    
    var icon:String!
    
    var city = City()
    
    var windsSpeed:String!
    
    private var content:ApiManager!
    
    private var viewModel:WeatherViewModel!
    
    override init() {
        super.init()
    }
    
    override init(json:[String:Any]) {
        
        city = City(json: json)
        
        let weatherJson = (json["weather"] as! [[String:Any]]).first!
        description = weatherJson["description"] as! String
        icon = weatherJson["icon"] as! String
        if let windsJson = json["wind"] as? [String:Any] {
            windsSpeed = String(windsJson["speed"] as! Double)
        }
        super.init(json: weatherJson)
        
    }
    
    init(viewModel:WeatherViewModel) {
        super.init()
        content = ApiManager(delegate: self)
        self.viewModel = viewModel
    }
    
    func getCityWeather(lat:Double,lng:Double) {
        content.getCityWeather(lat: lat, lng: lng)
    }
    
    func onPreExecute(action: ApiManager.ActionType) {
        viewModel.update(action: .wait)
    }
    
    func onPostExecute(status: BaseUrlSession.Status, action: ApiManager.ActionType, response: Any!) {
        viewModel.update(action: .idel)
        if status.success {
            switch action {
            case .getCityWeather:
                let weather = response as! Weather
                viewModel.update(action: .getCityWeather(weather: weather))
                break
            default:
                break
            }
        } else {
            viewModel.update(action: .onError(str: status.message))
        }
        
    }
    
}
