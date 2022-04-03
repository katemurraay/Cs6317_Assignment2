//
//  Match+CoreDataProperties.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 03/04/2022.
//
//

import Foundation
import CoreData


extension Match {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Match> {
        return NSFetchRequest<Match>(entityName: "Match")
    }

    @NSManaged public var duels: String?
    @NSManaged public var duelsWon: String?
    @NSManaged public var tackles: String?
    @NSManaged public var tacklesWon: String?
    @NSManaged public var passes: String?
    @NSManaged public var noPasses: String?
    @NSManaged public var date: String?
    @NSManaged public var name: String?
    @NSManaged public var redCards: String?
    @NSManaged public var yellowCards: String?
    @NSManaged public var minutesPlayed: String?
    @NSManaged public var playerId: String?

}

extension Match : Identifiable {

}
