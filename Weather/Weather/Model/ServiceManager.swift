//
//  ServiceManager.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import Foundation

struct ServiceManager {
    
    static let apiKey = "0f901c372f0e27b552215df39c513892"
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=\(apiKey)"
    static let geobytesURL = "http://gd.geobytes.com/AutoCompleteCity"
    
    
    func fetchWeatherData(from cityName: String){
        let url = URLState.openweather(cityName)
        performRequest(urlString: url.APIString)
    }
    
    func performRequest(urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching openweather data : \(error)")
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherData.self, from: safeData)
                        //print(decodedData.weather[0].description)
                    }
                    catch {
                        print("Err: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    // MARK: Geobytes autocomplete city API
    static func searchForCity(url: URL, completion: @escaping ([String]?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let safeData = String(data: data, encoding: .utf8)
            if let convertedData = safeData?.data(using: .utf8) {
                do {
                    let response = try JSONDecoder().decode([String].self, from: convertedData)
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion([], error)
                    }
                }
            }
        }
        task.resume()
        return task
    }

}

enum URLState{
    case geobytes(String)
    case openweather(String)
    
    var APIString: String{
        switch self {
        case .geobytes(let city):
            return ServiceManager.geobytesURL + "?q=\(city)"
        case .openweather(let weather):
            return ServiceManager.weatherURL + "?q=\(weather)"
            
        }
    }

    
}
