//
//  CityProtocol.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-14.
//

import Foundation

protocol TableCityDelegate:AnyObject {
    func citySelected(data : String)
}

protocol ServiceManagerDelegate {
    //func didUpdateWeather(weather: WeatherModel)
    func didTaskFail(error: Error)
}

