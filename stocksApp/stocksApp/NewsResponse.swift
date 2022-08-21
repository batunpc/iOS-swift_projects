//
//  NewsResponse.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-20.
//

import Foundation


struct NewsResponse : Codable {
    let id : String
    let sourceId :String
    let sourceName :String
    let providerName: String
    let title: String
    let publishedDate : String
}

