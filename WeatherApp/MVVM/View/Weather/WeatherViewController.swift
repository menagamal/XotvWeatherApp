//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by MINA AZIR on 1/27/19.
//  Copyright © 2019 MINA AZIR. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherViewController: UIViewController ,WeatherView {
    
    @IBOutlet weak var labelWinds: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelWeatherSubTitle: UILabel!
    @IBOutlet weak var labelWeatherMainTitle: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var lat:Double!
    var lng:Double!
    
    var weatherViewModel: WeatherViewModel!
    var weather:Weather!
    
    var loadingView:LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        
        loadingView = LoadingView(frame: self.view.frame)
        loadingView.setLoadingImage(image: UIImage(named: "loading")!)
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        loadingView.isHidden = true
        
        self.view.addSubview(loadingView)
        
        weatherViewModel = WeatherViewModel(view: self, vc: self)
        weatherViewModel.getCityWeather(lat: lat, lng: lng)
        
        
    }
    
    func setPageLayout()  {
        labelCity.text = weather.city.name
        labelWeatherMainTitle.text = weather.name
        labelWeatherSubTitle.text = weather.description
        let imgUrl = "http://openweathermap.org/img/w/\(weather.icon!).png"
        weatherImageView?.sd_setImage(with: URL(string: imgUrl), completed: nil)
        labelWinds.text = "Winds Speed \(weather.windsSpeed!)m/s"
    }
    
    func update(action: WeatherViewModel.Action) {
        switch action {
        case .idel:
            loadingView.setIsLoading(false)
            break
        case .wait:
            loadingView.setIsLoading(true)
            break
        case .getCityWeather(let weather):
            self.weather = weather
            setPageLayout()
            break
        case.onError(let str):
            Toast.showAlert(viewController: self, text: str)
            break
        }
    }


}
