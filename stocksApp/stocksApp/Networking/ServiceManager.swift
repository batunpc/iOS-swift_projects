//
//  ServiceManager.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18ı.
//

import Foundation


struct ServiceManager {
    //Specify the headers
    static let headers = [
        "X-RapidAPI-Key": "7a597de804mshe707082e4fc5b05p1a6e26jsn8a2f1859b519",
        "X-RapidAPI-Host": "ms-finance.p.rapidapi.com"
    ]
    
    // MARK: Finance API - autocomplete
    static func createRequest(route: Route,method: Method,
                              completion: @escaping (Result<[CompanyDetail]?, StocksError>) -> Void) -> URLRequest? {
        let urlString = Route.autoCompleteBaseURL + route.description /// concataneted URL
        guard let url = URL(string: urlString) else { return nil }
        let urlRequest = NSMutableURLRequest(url: url,cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 10.0)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers /// set the header
        
        switch method {
        case .get:
            URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { data, _, _ -> Void in
                guard let jsonData = data else {completion(.failure(.dataNotAvailable))
                    return
                }
                do {
                    let stockResults = try JSONDecoder().decode(StockResponse.self, from: jsonData)
                    let companyDetail = stockResults.results /// array of stocks
                    completion(.success(companyDetail))
                }catch{
                    completion(.failure(.dataFormatInvalid))
                }
            }).resume()
        }
        return urlRequest as URLRequest
    }
    
    
    // MARK: Finance API - GET realtime price
    static func getStockPrice(route: Route,method: Method,
                              completion: @escaping (Result<String, Error>) -> Void) -> URLRequest? {
        let urlString = Route.priceBaseURL + route.description
        guard let url = URL(string: urlString) else { return nil }
        let urlRequest = NSMutableURLRequest(url: url,cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 10.0)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers /// set the header
        
        switch method {
        case .get:
            URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error -> Void in
                guard let jsonData = data else { print(error!.localizedDescription)
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(StockModel.self, from: jsonData)
                    let lastPrice = decodedData.lastPriceString
                    completion(.success(lastPrice))
                }catch{
                    print(error.localizedDescription)
                }
            }).resume()
        }
        return urlRequest as URLRequest
    }
    
    //MARK: News API - GET news titles
    static func getNewsTitle(route: Route,method: Method,
                              completion: @escaping ([NewsResponse]) -> ()) -> URLRequest? {
        
        let urlString = Route.newsBaseURL + route.description
        guard let url = URL(string: urlString) else { return nil }
        let urlRequest = NSMutableURLRequest(url: url,cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 10.0)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers /// set the header
        
        switch method {
        case .get:
            URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error -> Void in
                guard let jsonData = data else { print(error!.localizedDescription)
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode([NewsResponse].self, from: jsonData)
                    completion(decodedData)
                }catch{
                    print(error.localizedDescription)
                }
            }).resume()
        }
        return urlRequest as URLRequest
    }
}
