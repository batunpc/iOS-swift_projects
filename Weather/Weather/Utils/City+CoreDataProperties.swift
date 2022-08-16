//
//  City+CoreDataProperties.swift
//  Weather
//
//  Created by Batuhan Ipci on 2022-08-16.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var city_name: String?
    @NSManaged public var city_temp: Double
    @NSManaged public var icon: String?

}

extension City : Identifiable {

}
