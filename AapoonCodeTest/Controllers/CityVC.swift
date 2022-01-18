//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import UIKit

class CityVC: UIViewController {
    
    var cityData:CityModel!
    
    @IBOutlet weak var wind_lbl: UILabel!
    @IBOutlet weak var humidity_lbl: UILabel!
    @IBOutlet weak var temp_lbl: UILabel!
    @IBOutlet weak var sunImageView: UIImageView!
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("city data",cityData.lat)
        weatherManager.delegate = self
        weatherManager.fetchWeather(latitude: cityData.lat, longitude: cityData.long)
        // Do any additional setup after loading the view.
    }
    
    
    
}
//MARK: - WeatherManagerDelegate
extension CityVC: WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temp_lbl.text = weather.tempratureInString
            self.sunImageView.image = UIImage(systemName: weather.conditionName)
            self.humidity_lbl.text = "Humidity:" + " " + String(weather.humidity) + "%"
            self.wind_lbl.text = "Wind:" + " " + weather.speedInString + " " + "km/h S"
        }
    }
    func didFailWithError(error: Error) {
        print(error)
        showToast(controller: self, message: error.localizedDescription, seconds: 1.0)
    }
    func networkError(error: String) {
        showToast(controller: self, message: error, seconds: 1.0)
    }
}
