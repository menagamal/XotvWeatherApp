//
//  ViewController.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController ,GMSMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapsView: GMSMapView!
    
    var lat = 31.9454
    var lon = 35.9284
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
        
        mapsView.delegate = self
        mapsView.camera = camera
        self.mapsView.isMyLocationEnabled = true
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapsView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        vc.lat = coordinate.latitude
        vc.lng = coordinate.longitude
        self.show(vc, sender: self)
        
    }
}

