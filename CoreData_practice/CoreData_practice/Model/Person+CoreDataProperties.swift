//
//  Person+CoreDataProperties.swift
//  CoreData_tuts
//
//  Created by Batuhan Ipci on 2022-08-08.
//
//

import Foundation
import CoreData
// MARK: Whatever changes you make on this file will be overwritten in the CoreData
/// if you add a new attribute or change any attribute name in this file, you need to
/// regenerate those Classes. So you can delete the current core data properties
//! Never delete the CoreDataClass file only properties

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: Int64

}

extension Person : Identifiable {

}
