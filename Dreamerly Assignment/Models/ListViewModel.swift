//
//  ListViewModel.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/13/24.
//

import Foundation
import SwiftUI
import CoreData

class ListViewModel: ObservableObject {
    @Published private var tasks: [Tasks] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Tasks.taskListName, ascending: true)]
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func filteredTasks(_ searchText: String) -> [Tasks] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { $0.taskListName?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    func deleteTasks(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(tasks[index])
            }
            saveContext()
            fetchTasks()
        }
    }
    
    func addList(taskListName:ListItem) {
        withAnimation {
            let newList = Tasks(context: context)
            newList.listid = UUID()
            newList.taskListName = taskListName.textContent
            newList.timestamp = Date()
            newList.themecolor = taskListName.color.toHex()
            newList.tag = taskListName.tagColor.toHex()
            saveContext()
            fetchTasks()
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
