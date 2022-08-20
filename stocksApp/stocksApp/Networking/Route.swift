//
//  Route.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18.
//

import Foundation


enum Route{
    //To autocomplete the company - get the performance-ID from autocomplete
    static let autoCompleteBaseURL = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete"
    //GET realtime price
    static let priceBaseURL = "https://ms-finance.p.rapidapi.com/stock/v2/get-realtime-data"
    //GET news titles
    static let newsBaseURL = "https://ms-finance.p.rapidapi.com/news/list"
    
    case companySearch(String)
    case realTimePrice(String)
    case newsTitles(String)
    
    var description: String{
        switch self {
        case.companySearch(let stock):
            return "?q=\(stock)"
        case.realTimePrice(let performanceID):
            return "?performanceId=\(performanceID)"
        case.newsTitles(let performanceID):
            return "?performanceId=\(performanceID)"
        }
    }
}

// Error handling
enum StocksError:Error{
    case dataNotAvailable
    case dataFormatInvalid
    
    var description: String{
        switch self {
            case .dataNotAvailable:
                return "Aborting"
            case .dataFormatInvalid:
                return "Searchbar is either empty or data is Invalid"
        }
    }
}
