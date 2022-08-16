//
//  WeatherData.swift
//  WeatherDataResponse
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import Foundation



struct WeatherDataResponse : Codable {
    let name: String
    let main : Main // Object
    let weather: [Weather] //Array
}

struct Main: Codable {
    let temp: Double
//    let feelsLike: Double
//    let tempMin: Double
//    let tempMax: Double
//    let pressure: Int
//    let humidity: Int

}

struct Weather: Codable {
    let icon: String
}
