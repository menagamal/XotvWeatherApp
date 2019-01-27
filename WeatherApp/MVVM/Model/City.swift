//
//  City.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import Foundation

class City:BaseModel {
    
    var lat:Double!
    var lng:Double!
    
    override init() {
        super.init()
    }
    
    override init(json:[String:Any]) {
        
        super.init(json: json)
        if let cordinateJson = json["coord"] as? [String:Any] {
            
            lat = cordinateJson["lat"] as! Double
            lng = cordinateJson["lon"] as! Double
            
        }
      
    }
    
}
