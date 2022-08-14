//
//  ServiceManager.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import Foundation

struct ServiceManager {
    
    static let apiKey = "0f901c372f0e27b552215df39c513892"
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=\(apiKey)&units=metric"
    static let geobytesURL = "http://gd.geobytes.com/AutoCompleteCity"
    
    
    func fetchWeatherData(from cityName: String){
        let url = URLState.openweather(cityName)
        performRequest(urlString: url.stringValue)
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
    static func searchCity(from url: String, completionHandler: @escaping (Result<Data, URLError>) -> Void) {
        guard let safeURL = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: safeURL) { data, response, error in
            if let urlError = error as? URLError {
                DispatchQueue.main.async {
                    completionHandler(.failure(urlError))
                }
                
            }
            if let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            }
          }
        task.resume()
    }

}
enum URLState{
    
    case geobytes(String)
    case openweather(String)
    
    var stringValue: String{
        switch self {
        case .geobytes(let city):
            return ServiceManager.geobytesURL + "?q=\(city)"
        case .openweather(let weather):
            return ServiceManager.weatherURL + "?q=\(weather)"
            
        }
    }
    
}
