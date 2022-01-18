//
//  WeatherData.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//


import Foundation
struct WeatherData: Codable
{
    let name: String
    let main: Main
    let wind:Wind
    let weather: [Weather]
}

struct Wind:Codable {
    let speed:Double
}
struct Main: Codable {
    let temp: Double
    let humidity:Int
    
}
struct Weather: Codable {
    let id: Int
    let description: String
}
