//
//  UsersDB+CoreDataProperties.swift
//  list
//
//  Created by MACM72 on 24/06/25.
//
//

import Foundation
import CoreData


extension UsersDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersDB> {
        return NSFetchRequest<UsersDB>(entityName: "UsersDB")
    }

    @NSManaged  var usersList: UsersListWrapper?

}

extension UsersDB : Identifiable {

}
