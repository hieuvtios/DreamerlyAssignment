//
//  Tasks+CoreDataProperties.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/14/24.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var listid: UUID?
    @NSManaged public var tag: String?
    @NSManaged public var taskListName: String?
    @NSManaged public var themecolor: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var notes: Note?

}

extension Tasks : Identifiable {

}
