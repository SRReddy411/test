//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import Foundation


//MARK: - Weather ManagerDelegate protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    func networkError(error:String)
}
//MARK: - WeatherManager struture
struct WeatherManager
{
     
    var delegate: WeatherManagerDelegate?
    let weatherURL = APICostants.TODAY_FORECAST_API
    
    func fetchWeather(cityName: String)
    {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double,longitude: Double)
    {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    //getting json data from server
    func performRequest(with urlString: String)
    {
        if ReachabilityFile .isConnectedToNetwork() {
            //1. Create a URL
            if let url = URL(string: urlString)
            {
                //2.Create a URLSession
                let session = URLSession(configuration: .default)
                //3.Give the session a task
                let task = session.dataTask(with: url) { (data, response, error) in
                    
                    print("response of lat and long",response,urlString)
                    if error != nil
                    {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data
                    {
                        if let weather = self.parseJSON(safeData) {
                            
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
                //4.Start the task
                task.resume()
            }
        }else{
            self.delegate?.networkError(error: "please check network connection")
        }
    }
    //decoding json format to swift format
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            
            print("temparature ",decodedData.main.temp)
            
            
            let temp = decodedData.main.temp
            let humidy = decodedData.main.humidity
            
            let windSpeed = decodedData.wind.speed
            
            print("humidity speed",humidy,windSpeed ?? 67)
            let weather = WeatherModel(conditonId: id, cityName: cityName, temprature: temp,humidity:humidy,windSpeed:windSpeed)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

