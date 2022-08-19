//
//  ServiceManager.swift
//  Weather
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
    
    // MARK: Finance autocomplete
    static func createRequest(route: Route,method: Method,
                              completion: @escaping (Result<[CompanyDetail]?, StocksError>) -> Void) -> URLRequest? {
        
        let urlString = Route.baseURL + route.description /// concataneted URL
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
                    let stockResults = try JSONDecoder().decode(Results.self, from: jsonData)
                    let companyDetail = stockResults.results /// array of stocks
                    completion(.success(companyDetail))
                }catch{
                    completion(.failure(.dataFormatInvalid))
                }
            }).resume()
        }
        return urlRequest as URLRequest
    }
}
