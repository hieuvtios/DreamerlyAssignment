//
//  Note+CoreDataProperties.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/14/24.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var listid: UUID?
    @NSManaged public var noteid: String?
    @NSManaged public var notename: String?
    @NSManaged public var order: Int64
    @NSManaged public var timestamp: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var tasks: Tasks?
    @NSManaged public var duedate: Date?
    @NSManaged public var reminddate: Date?



}

extension Note : Identifiable {

}
