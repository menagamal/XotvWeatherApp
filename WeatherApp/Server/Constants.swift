//
//  Constants.swift
//  Syariti
//
//  Created by Mena on 9/17/17.
//  Copyright © 2017 Mena. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

public class Constants {
    
    public static let API_KEY = "dad76558e0d071819b3f8d61e71f7719"
    public static let API_SUCCESS_CODE = 200
    
    public static let PRIMARY_COLOR = UIColor(red: 0xEE / 255, green: 0x9B / 255, blue: 0x1A / 255, alpha: 1)
    
    public static let DEVICE_TYPE = 2
    public static let APP_TIME_FORMAT = "hh:mm a"
    public static let DOMAIN_NAME = "http://api.openweathermap.org/data/2.5/weather?"
    private static let version = "v1"
    
    public static let BASE_URL = "\(DOMAIN_NAME)APPID=\(API_KEY)&"
    
 //   public static let IMAGE_URL = "\(DOMAIN_NAME)/storage/app/"
    
    public static var language: String {
        
        get {
            
            return Locale.current.identifier.contains("ar") ? "ar" : "en"
        }
    }
    
    public static func getAppLanguage() -> String {
        
        let defaults = UserDefaults.standard
        
        if let langs = defaults.stringArray(forKey: "AppleLanguages") {
            
            switch langs[0] {
            case "en-AL":
                return "عربي"
            default:
                break
            }
        }
        
        return "English"
    }
    
    public static func setAppLanguage(language: String) {
        
        let defaults = UserDefaults.standard
        switch language {
        case "ar":
            defaults.set(["ar", "en"], forKey: "AppleLanguages")
            break
        default:
            defaults.set(["en", "ar"], forKey: "AppleLanguages")
            break
        }
        defaults.synchronize()
    }
    
    public static func openMapForPlace(location: CLLocationCoordinate2D) {
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Patient"
        mapItem.openInMaps(launchOptions: options)
    }
}
