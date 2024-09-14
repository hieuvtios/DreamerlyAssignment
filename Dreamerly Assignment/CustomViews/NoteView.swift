import SwiftUI
import UIKit // Import UIKit to access UIImpactFeedbackGenerator

struct NoteView: View {
    @ObservedObject var noteItem: Note
    @State private var isCompleted: Bool = false // State to track completion
    @Environment(\.managedObjectContext) private var viewContext // Access the Core Data context
    var doSomething : () -> ()
    var body: some View {
        HStack {
            Image(systemName: noteItem.isCompleted ? "checkmark.circle.fill" : "circle")
                .frame(width: 30, height: 40)
                .foregroundColor(noteItem.isCompleted ? .green : .gray) // Change color based on completion
                .onTapGesture {
                    toggleCompletion()
                    doSomething()
                }
                Text(noteItem.notename ?? "no name")
                .strikethrough(isCompleted, color: .gray) // Apply strikethrough based on isCompleted state

            Spacer()
        }
        .contentShape(Rectangle())
    }
    private func updateNoteCompletion() {
            noteItem.isCompleted.toggle()
            do {
                try viewContext.save() // Save changes to Core Data
            } catch {
                print("Failed to update note completion: \(error)")
            }
        }
    private func toggleCompletion() {
        updateNoteCompletion() // Update Core Data
        isCompleted.toggle() // Toggle completion state
        Utilities.shared.provideHapticFeedback() // Provide haptic feedback
    }


}
