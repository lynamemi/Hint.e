//
//  Player+CoreDataProperties.swift
//  Hint.e
//
//  Created by Emily Lynam on 9/21/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player");
    }

    @NSManaged public var name: String?
    @NSManaged public var score: Int32

}
