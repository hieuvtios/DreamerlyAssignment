//
//  NoteDetail.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/14/24.
//

import SwiftUI
import CoreData

struct NoteDetailView: View {
    @ObservedObject var noteItem: Note // Use @ObservedObject
    @State private var name: String = ""
    @State private var isCompleted: Bool = false // State to track completion
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext // Core Data context
    @FocusState private var keyboardFocused: Bool
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // or .medium, .short for different styles
        formatter.timeStyle = .short // or .none if you don't want to show time
        return formatter
    }()
    let dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long // or .medium, .short for different styles
        return formatter
    }()
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Image(systemName: noteItem.isCompleted ? "checkmark.circle.fill" : "circle")
                    .frame(width: 30, height: 40)
                    .foregroundColor(noteItem.isCompleted ? .green : .gray) // Change color based on completion
                    .onTapGesture {
                        noteItem.isCompleted.toggle()
                    }

                TextField("Title", text: $name,  axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2)
            }
            VStack(alignment:.leading,spacing:30){
                HStack{
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                    Text("Add sub-task")
                    Spacer()
                }
                    .onTapGesture {
                        print("add sub task")
                    }
                Button {
                    // show remind me
                } label: {
                    HStack(alignment:.center){
                        Image(systemName:"bell")
                            .foregroundStyle(.blue)

                        Text("Remind at \(noteItem.reminddate.map { dateFormatter.string(from: $0) } ?? "No date set")")
                            .foregroundStyle(.blue)
                            .lineLimit(1)
                        
                    }
                }
                Button {
                    // show calendar
                } label: {
                    HStack{
                        Image(systemName:"calendar")
                            .foregroundStyle(.blue)

                        Text("Due \(noteItem.duedate.map { dateFormatter2.string(from: $0) } ?? "No date set")")
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .padding()
        .onAppear(){
            name = noteItem.notename ?? ""
        }
        .onDisappear(){
            noteItem.notename = name
            saveItem()
        }
        .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: deleteNote) {
                          Image(systemName: "trash")
                      }
                  }
              }
    }
    private func toggleCompletion() {
        noteItem.isCompleted.toggle()
        updateNoteCompletion() // Update Core Data
        noteItem.isCompleted.toggle() // Toggle completion state
        Utilities.shared.provideHapticFeedback() // Provide haptic feedback
    }
    private func deleteNote() {
           viewContext.delete(noteItem)

           do {
               try viewContext.save()
               dismiss() // Dismiss the view after deletion
           } catch {
               let nsError = error as NSError
               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
           }
       }
    private func updateNoteCompletion() {
            noteItem.isCompleted.toggle()
            
            do {
                try viewContext.save() // Save changes to Core Data
            } catch {
                print("Failed to update note completion: \(error)")
            }
        }
    func saveItem() {
       do {
           noteItem.notename = name
           try viewContext.save()
       } catch {
           let nsError = error as NSError
           fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
       }
   }

}

