//
//  Stock+CoreDataProperties.swift
//  stocksApp
//
//  Created by Batuhan Ipci on 2022-08-20.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var lastPrice: Double
    @NSManaged public var category: String?
    @NSManaged public var performanceID: String?

}

extension Stock : Identifiable {

}
