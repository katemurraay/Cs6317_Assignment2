//
//  Player+CoreDataProperties.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 01/04/2022.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var age: String?
    @NSManaged public var appearances: String?
    @NSManaged public var country: String?
    @NSManaged public var dob: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var joinedDate: String?
    @NSManaged public var name: String?
    @NSManaged public var position: String?
    @NSManaged public var team: String?
    @NSManaged public var totalGoals: String?
    @NSManaged public var url: String?
    @NSManaged public var toFavourites: NSSet?

}

// MARK: Generated accessors for toFavourites
extension Player {

    @objc(addToFavouritesObject:)
    @NSManaged public func addToToFavourites(_ value: Favourite)

    @objc(removeToFavouritesObject:)
    @NSManaged public func removeFromToFavourites(_ value: Favourite)

    @objc(addToFavourites:)
    @NSManaged public func addToToFavourites(_ values: NSSet)

    @objc(removeToFavourites:)
    @NSManaged public func removeFromToFavourites(_ values: NSSet)

}

extension Player : Identifiable {

}
