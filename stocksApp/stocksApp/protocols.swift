//
//  protocols.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-19.
//

import Foundation

protocol TableStocksDelegate:AnyObject {
    func companySelected(data : CompanyDetail)
}

