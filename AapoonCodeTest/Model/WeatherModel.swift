//
//  WeatherModel.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import Foundation


struct WeatherModel
{
    //Stored Properties
    let conditonId: Int
    let cityName: String
    let temprature: Double
    let humidity:Int
    let windSpeed:Double
    
    //Computed Properties
    
    var speedInString: String
    {
        return String(format: "%.1f", windSpeed)
    }
    var tempratureInString: String
    {
        return String(format: "%.1f", temprature)
    }
    var conditionName: String {
        switch conditonId {
            
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}



struct CityModel {
     let lat: Double
        let long: Double
        let name: String
         
}
