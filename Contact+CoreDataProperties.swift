//
//  Contact+CoreDataProperties.swift
//  Tableviewdemo
//
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var address: String?
    @NSManaged public var avatar: Data?
    @NSManaged public var fullname: String?
    @NSManaged public var phoneNumber: String?

}

extension Contact : Identifiable {

}
