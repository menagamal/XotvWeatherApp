
//
//  ContentSession.swift
//  Syariti
//
//  Created by Mena on 9/20/17.
//  Copyright © 2017 Mena. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class ApiManager: BaseUrlSession {
    
    var delegate: ApiManagerDelegate!
    let baseUrl = Constants.BASE_URL
    
    public enum ActionType {
        case getCityWeather,None
    }
    
    override init() {
        super.init()
        
    }
    
    convenience init<T: ApiManagerDelegate>(delegate: T)  {
        self.init()
        
        self.delegate = delegate
    }
    
    func getCityWeather(lat:Double,lng:Double) {
        let  params =  [String: Any]()
        
        let actionType = ActionType.getCityWeather
      
        let url = URL(string: "\(baseUrl)lat=\(lat)&lon=\(lng)")!
       // let url = URL(string: "\(baseUrl)q=Egypt")!
        
        requestConnection(action: actionType, method: "get", url: url, body: params, shouldCache: false)
    }
    //api.openweathermap.org/data/2.5/weather?/APPID=dad76558e0d071819b3f8d61e71f7719&q=United%20States
    //api.openweathermap.org/data/2.5/weather?/APPID=dad76558e0d071819b3f8d61e71f7719&q=United%20States
    //api.openweathermap.org/data/2.5/weather?APPID=dad76558e0d071819b3f8d61e71f7719&q=United%20States
   
    private func getHeaderlessBase64(image: UIImage!) -> String! {
        var value: String! = nil
        if (image != nil) {
            let data = UIImagePNGRepresentation(image)
            
            value = data?.base64EncodedString()
        }
        
        return value
    }
    
    func getUDID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    override func onPreExecute(action: Any) {
        delegate.onPreExecute(action: action as! ApiManager.ActionType)
    }
    
    func onPreExecute(action: ActionType) {
        delegate.onPreExecute(action: action)
    }
    
    override func onSuccess(action: Any, response: URLResponse!, data: Data!) {
        
        let actionType: ActionType = action as! ApiManager.ActionType
        let res = String(data: data, encoding: .utf8)
        print(res ?? "")
        
        do {
            
            var jsonObject = [String: Any]()
            var jsonArray = [[String: Any]]()
            if let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                
                jsonObject = object
            } else if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                
                jsonArray = array
            }
            
            var success = true
            
            let code = jsonObject["cod"] as? Int ?? -1
            
            if code != Constants.API_SUCCESS_CODE {
                success = false
            }
            
            if success {
                switch actionType {
                case.getCityWeather:
                    let weather = Weather(json: jsonObject)
                    delegate.onPostExecute(status: Status(200, true, ""), action: actionType, response: weather)
                    break
                default:
                    break
                }
            } else {
                let codeMessage = jsonObject["messages"] as? String ?? "Not Found"
                onFailure(action: actionType, error: NSError(domain: codeMessage, code: code, userInfo: nil))
            }
        } catch {
            
            onFailure(action: actionType, error: error as NSError)
        }
    }
    
    override func onFailure(action: Any, error: NSError) {
        delegate.onPostExecute(status: Status(error: error), action: action as! ApiManager.ActionType, response: nil)
    }
}

public protocol ApiManagerDelegate {
    
    func onPreExecute(action: ApiManager.ActionType)
    
    func onPostExecute(status: BaseUrlSession.Status, action: ApiManager.ActionType, response: Any!)
}
