//
//  ServiceManager.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-13.
//

import Foundation

struct ServiceManager {
    static var delegate : ServiceManagerDelegate?
    static let APIKey = "0f901c372f0e27b552215df39c513892"
    static let APIParam = "&appid=\(APIKey)"
    
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    static let geobytesURL = "http://gd.geobytes.com/AutoCompleteCity"
    
    
    static func getWeatherData(with urlString: String, complition : @escaping (WeatherModel)->()){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
             session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didTaskFail(error: error)
                }
                if let data = data {
                    if let weather = self.parseJSON(weatherData: data){
                        complition(weather)
                    }
                }
            }.resume()
        }
    }
                
    static func parseJSON(weatherData: Data) -> WeatherModel?{
        do{
            let decodedData = try JSONDecoder().decode(WeatherDataResponse.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let icon = decodedData.weather[0].icon
        
            let weather = WeatherModel(cityName: name, icon: icon, temperature: temp)
            return weather
        }catch{
            delegate?.didTaskFail(error: error)
            return nil
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
                }catch {
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
            + "&units=metric" + ServiceManager.APIParam
            
        }
    }

    
}
