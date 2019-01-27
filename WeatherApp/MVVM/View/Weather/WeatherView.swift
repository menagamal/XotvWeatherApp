//
//  WeatherView.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherView {
    
    var weatherViewModel: WeatherViewModel! {
        get set
    }
    
    func update(action: WeatherViewModel.Action)
}

