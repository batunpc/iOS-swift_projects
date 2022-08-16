//
//  WeatherModel.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-15.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let icon : String
    let temperature : Double
    
    var tempString: String{
        return String(format: "%.1f", temperature)
    }
}
