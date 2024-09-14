//
//  Task.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/14/24.
//

import Foundation

//TAsk model and sample task
struct Task: Identifiable{
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

struct TaskMetaData: Identifiable{
    var id = UUID().uuidString
    var task : [Task]
    var taskDate : Date
}

func getSampleDate(offset:Int) -> Date{
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day,value: offset, to: Date())
    return date ?? Date()
}

var tasks : [TaskMetaData] = [
    TaskMetaData(task: [
        Task(title: "Talk to Justin"),
        Task(title: "Go to work"),
        Task(title: "Hanging out with my son")
    ], taskDate: getSampleDate(offset: 1)),TaskMetaData(task: [
        Task(title: "Dummy task"),
        Task(title: "Dummy task 2"),
        Task(title: "Dummy task 3")
    ], taskDate: getSampleDate(offset: 10))
]
