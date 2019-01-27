//
//  BaseSession.swift
//  Barek
//
//  Created by Abanoub Osama on 12/11/16.
//  Copyright © 2016 Abanoub Osama. All rights reserved.
//

import UIKit
import Alamofire
//import Just

public class BaseUrlSession {
    
    public struct Status {
        
        var code: Int
        var success: Bool
        var message: String
        
        init(error: NSError) {
            code = error.code
            success = false
            message = error.domain
        }
        
        init(_ c: Int, _ s: Bool, _ m: String) {
            code = c
            success = s
            message = m
        }
    }
    
    public enum Actions {
    }
    
    func requestConnection(action: Any, url: URL, shouldCache: Bool) {
        requestConnection(action: action, method: "GET", url: url, body: nil, header: nil, shouldCache: shouldCache, shouldLoadFromCache: false)
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, shouldCache: Bool) {
        requestConnection(action: action, method: method, url: url, body: body, header: nil, shouldCache: shouldCache, shouldLoadFromCache: false)
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, header: [String: String]!, shouldCache: Bool) {
        requestConnection(action: action, method: method, url: url, body: body, header: header, shouldCache: shouldCache, shouldLoadFromCache: false)
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, header: [String: String]!, file: Data, fileKey: String, fileName: String) {
        
        onPreExecute(action: action)
        
//        let manager = SettingsManager()
//        var mHeader = header ?? [String: String]()
//
//        let token = manager.getUserToken()
//        if !token.isEmpty {
//
//            mHeader["Authorization"] = "Bearer \(token)"
//        } else if let param = body, let token = param["token"] as? String {
//
//            mHeader["Authorization"] = "Bearer \(token)"
//        }
//        mHeader["Accept"] = "application/json"
        
        let mBody = body ?? [String: Any]()
        
        let method = HTTPMethod(rawValue: method.uppercased())!
        
        let urlRequest = try! URLRequest(url: url, method: method, headers: nil)
        
        Alamofire.upload(multipartFormData: { (data) in
            
            data.append(file, withName: fileKey, fileName: fileName, mimeType: "application/pdf")
            
            for (key, value) in mBody {
                data.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }, with: urlRequest) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    self.onSuccess(action: action, response: response.response, data: response.data!)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                if !NetworkReachabilityManager()!.isReachable {
                    
                    self.onFailure(action: action, error: NSError(domain: NSLocalizedString("no_internet", comment: ""), code: -1, userInfo: nil))
                } else {
                    self.onFailure(action: action, error: encodingError as NSError)
                }
                
            }
        }
    }
    
    func requestConnection(action: Any, method: String, url: URL, body: [String: Any]!, header: [String: String]!, image: UIImage, imageKey: String, fileName: String) {
        
        onPreExecute(action: action)
        
//        let manager = SettingsManager()
//        var mHeader = header ?? [String: String]()
//
//        let token = manager.getUserToken()
//        if !token.isEmpty {
//
//            mHeader["Authorization"] = "Bearer \(token)"
//        } else if let param = body, let token = param["token"] as? String {
//
//            mHeader["Authorization"] = "Bearer \(token)"
//        }
//        mHeader["Accept"] = "application/json"
        
        let mBody = body ?? [String: Any]()
        
        let method = HTTPMethod(rawValue: method.uppercased())!
        
        let urlRequest = try! URLRequest(url: url, method: method, headers: nil)
        
        let imgData = UIImageJPEGRepresentation(self.resizeImage(image: image, newWidth: 200), 1)!
        
        Alamofire.upload(multipartFormData: { (data) in
            //  data.append(imgData, withName: "image")
            data.append(imgData, withName: imageKey, fileName: fileName, mimeType: "image/jpg")
            
            for (key, value) in mBody {
                data.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }, with: urlRequest) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    self.onSuccess(action: action, response: response.response, data: response.data!)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                if !NetworkReachabilityManager()!.isReachable {
                    
                    self.onFailure(action: action, error: NSError(domain: NSLocalizedString("no_internet", comment: ""), code: -1, userInfo: nil))
                } else {
                    self.onFailure(action: action, error: encodingError as NSError)
                }
                
            }
        }
    }
    
    func requestConnection(action: Any, method: String = "get", url: URL, body: [String: Any]! = nil, header: [String: String]! = nil, shouldCache: Bool = true, shouldLoadFromCache: Bool) {
        
        onPreExecute(action: action)
        
        let mHeader = header ?? [String: String]()

        var cachePolicy: URLRequest.CachePolicy!
        if shouldLoadFromCache {
            
            cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
        } else if shouldCache {
            
            cachePolicy = URLRequest.CachePolicy.reloadRevalidatingCacheData
        } else {
            
            cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        }
        
        // encoding: URLEncoding.httpBody, headers: mHeader
        
        let method = HTTPMethod(rawValue: method.uppercased())
        
        Alamofire.request(url, method: method!, parameters: body, encoding: URLEncoding.httpBody, headers: mHeader).response { (response) in
            
            if let error = response.error {
                print(error)
                if !NetworkReachabilityManager()!.isReachable {
                    
                    self.onFailure(action: action, error: NSError(domain: NSLocalizedString("no_internet", comment: ""), code: -1, userInfo: nil))
                } else {
                    self.onFailure(action: action, error: error as NSError)
                }
            } else {
                self.onSuccess(action: action, response: response.response, data: response.data!)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print(jsonResult)
                } catch {
                    print(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue) ?? "")
                }
            }
        }
    }
    
    func getCacheData(url: URL) -> Data! {
        
        if let cache = URLCache().cachedResponse(for: URLRequest(url: url)) {
            return cache.data
        }
        
        return nil
    }
    
    func getCache(url: URL) -> Any! {
        
        if let cache = URLCache().cachedResponse(for: URLRequest(url: url)) {
            do {
                let response = try JSONSerialization.jsonObject(with: cache.data, options: JSONSerialization.ReadingOptions.mutableContainers)
                return response
            } catch {
                print("Error:\(error)")
            }
        }
        
        return nil
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func onPreExecute(action: Any) {
    }
    
    func onSuccess(action: Any, response: URLResponse!, data: Data!) -> Void {
        preconditionFailure("This method must be overriden")
    }
    
    func onFailure(action: Any, error: NSError) -> Void {
        preconditionFailure("This method must be overriden")
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension Dictionary {
    
    static func += <k, v> (left: inout [k: v], right: [k: v]) {
        
        for (k, v) in right {
            
            left[k] = v
        }
    }
}

