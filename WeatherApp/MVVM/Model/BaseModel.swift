//
//  BaseModel.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import Foundation

class BaseModel {
    
    var id:Int!
    var name:String!
    
    init() {
        
    }
    
    init(json:[String:Any]) {
        
        id = json["id"] as! Int
        
        if let str = json["name"] as? String {
            name = str
        } else if let str = json["main"] as? String {
            name = str
        }
        
    }
}
