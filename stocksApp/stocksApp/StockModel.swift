//
//  StockModel.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-19.
//

import Foundation

struct StockModel : Codable{
    let lastPrice : Double
    var lastPriceString: String{
        return String(format: "%.3f", lastPrice)
    }
}

struct CompanyValue {
    var id :String , selectedCompany:String, selectedCategory:String
}
