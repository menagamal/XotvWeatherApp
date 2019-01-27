//
//  Weather.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import Foundation
import Cache

class Weather:BaseModel ,ApiManagerDelegate ,NSCoding {
    
    var weatherDescription:String!
    
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
        weatherDescription = weatherJson["description"] as! String
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
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.weatherDescription = aDecoder.decodeObject(forKey: "description") as! String
        self.icon = aDecoder.decodeObject(forKey: "icon") as! String
        
        self.windsSpeed = aDecoder.decodeObject(forKey: "windsSpeed") as! String
        
        self.city.id = aDecoder.decodeObject(forKey: "cityId")  as! Int
        self.city.name = aDecoder.decodeObject(forKey: "cityName") as! String
        self.city.lat = aDecoder.decodeObject(forKey: "cityLat") as! Double
        self.city.lng = aDecoder.decodeObject(forKey: "cityLng") as! Double
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(weatherDescription, forKey: "description")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(windsSpeed, forKey: "windsSpeed")

        
        aCoder.encode(city.id, forKey: "cityId")
        aCoder.encode(city.name, forKey: "cityName")
        aCoder.encode(city.lat, forKey: "cityLat")
        aCoder.encode(city.lng, forKey: "cityLng")
        
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
