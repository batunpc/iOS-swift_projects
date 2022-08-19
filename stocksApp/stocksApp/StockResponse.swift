//
//  StockResponse.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-19.
//

import Foundation


struct Results: Codable {
    let count : Int
    let pages : Int
    let results : [CompanyDetail]
}

struct CompanyDetail: Codable {
    let name : String
}



