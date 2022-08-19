//
//  Route.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-18.
//

import Foundation

//enum Route {
//    static let baseURL = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete"
//
//    case temp
//
//    var description: String {
//        switch self {
//        case .temp: return "/temp"
//        }
//    }
//}
enum Route{
    
    static let baseURL = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete"

    case financeSearch(String)

    var description: String{
        switch self {
        case .financeSearch(let stock):
            return "?q=\(stock)"

        }
    }
}
