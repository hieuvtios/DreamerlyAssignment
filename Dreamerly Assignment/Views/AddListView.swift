import SwiftUI
import CoreData


enum TaskStatus : CustomStringConvertible {
    case finished
    case unfinished
    
    var description : String {
        switch self {
        case .finished: return "Finished"
        case .unfinished: return "Doing"
        }
    }
}

struct AddListView: View {
    @State private var isKeyboardShowing: Bool = false
    @State private var noteContent: String = ""
    @State private var selectedFilter: TaskStatus = .unfinished
    @State private var dueDate: Date = Date()
    @State private var remindAt: Date = Date()
    @FocusState private var keyboardFocused: Bool
    var selectedLists: Tasks
    @State private var addTapped: Bool = false
    @State var showPopUpChangeText: Bool = false
    @State var listName = ""
    @Environment(\.managedObjectContext) private var viewContext
    @State private var notes: [Note] = [] // State variable to store fetched results
    @State private var refreshID = UUID()   // can be actually anything, but unique
    @State var color: Color = Color.clear
    let settingsOptions: [SettingsItem] = [
//        SettingsItem(iconName: "pencil", type: .changeName, settingsText: "Change Name"),
//        SettingsItem(iconName: "square.and.pencil", type: .edit, settingsText: "Edit"),
//        SettingsItem(iconName: "arrow.up.arrow.down", type: .sort, settingsText: "Sort"),
        SettingsItem(iconName: "paintbrush", type: .changeTheme, settingsText: "Change Theme"),
        SettingsItem(iconName: "trash", type: .deleteList, settingsText: "Delete List")
    ]
    fileprivate func filterMenu() -> some View {
        return Menu {
            Button {
                selectedFilter = .unfinished
            } label: {
                Text("Doing")
                    .font(.footnote) // Apply footnote style
            }
            Button {
                selectedFilter = .finished
            } label: {
                Text("Finished")
                    .font(.footnote) // Apply footnote style
            }
        } label: {
            HStack {
                Image(systemName:"chevron.up.chevron.down")
                Text("\(selectedFilter.description)")
            }
            .padding(.vertical,0)
            .padding(.horizontal,20)
        }
    }
    
    var body: some View {
        ZStack {
            color.ignoresSafeArea()
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                filterMenu()
                List {
                    ForEach(notes) { note in
                        NavigationLink(destination: NoteDetailView(noteItem: note)) {
                            NoteView(noteItem: note) {
                                withAnimation {
                                    if let index = notes.firstIndex(where: { $0.id == note.id }) {
                                        notes.remove(at: index)
                                    }
                                }
                            }
                            .frame(height: 40)
                            .contentShape(Rectangle()) // Ensures the entire area is tappable
                        }
                        .listRowSeparator(.hidden, edges: .all)
                        .transition(.move(edge: .trailing)) // Slide in from the right
                    }
                    .onMove(perform: moveItem)
                    .listRowBackground(RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .padding(.bottom,5)
                        .padding(.horizontal, 0)
                    )
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .id(refreshID)
                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    if (!addTapped) {
                        AddATaskButton(addTapped: $addTapped).padding(.horizontal, 12)
                    }
                    if (addTapped) {
                        VStack(spacing:0) {
                            Spacer().frame(height: 10)
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.secondary)
                                TextField("Add a Task", text: $noteContent,axis: .vertical)
                                    .lineLimit(2)
                                    .focused($keyboardFocused)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            keyboardFocused = true
                                        }
                                    }
                            }
                            Spacer().frame(height: 20)
                            DatePicker(selection: $dueDate, displayedComponents: .date) {
                                Text("Due date: ")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(10)
                            .padding(.vertical,5)
                            DatePicker("Remind me: ", selection: $remindAt,displayedComponents: [.date, .hourAndMinute])
                                .foregroundStyle(.secondary)
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding(10)
                                .padding(.vertical,5)
                        }
                        .padding(10)
                        .ignoresSafeArea()
                        .background(Color.white)
                    }
                    Spacer()
                }
            }
            .navigationTitle($listName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if (keyboardFocused) {
                            if (noteContent.isEmpty) {
                                dismissKeyboardAndTapGesture()
                                return
                            }
                            addNewNote(withNoteContent: noteContent,dueDate: dueDate,remindAt: remindAt)
                            // create a local nofication with remind At
                            noteContent = ""
                            dismissKeyboardAndTapGesture()
                        } else {
                            showPopUpChangeText.toggle()
                        }
                    } label: {
                        if (keyboardFocused) {
                            Text("Done")
                        } else {
//                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
            if(notes.count == 0){
                Text("No \(selectedFilter.description.lowercased()) task")
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: selectedFilter) { _ in
            fetchNotes() // Fetch notes when the filter changes
        }
        .onChange(of: listName) { newValue in
            selectedLists.taskListName = newValue
        }
      
       
        .onAppear {
            listName = selectedLists.taskListName ?? ""
            color = Color(hex: selectedLists.themecolor ?? "FFFFFF")
                fetchNotes() // Fetch notes when the view appears
        }
        .popup(isPresented: $showPopUpChangeText) {
            ZStack {
                VStack(spacing: 10) {
                    Spacer().frame(height: 5)
                    Rectangle().frame(width: 30,height: 4).foregroundColor(.secondary).cornerRadius(2, corners: .allCorners)
                    Text("List Options")
                    List(settingsOptions) { item in
                        HStack {
                            if !item.iconName.isEmpty {
                                Image(systemName: item.iconName)
                                    .foregroundColor(.primary)
                            }
                            Text(item.settingsText)
                                .font(.footnote)
                            Spacer()
                            if(item.iconName == "paintbrush" ){
                                ColorPicker("",selection: $color)
                                    .font(.caption)
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(5)
                        .listRowSeparator(.hidden)  // Removes row separators for each row

                    }
                    .scrollDisabled(true)
                    .listStyle(PlainListStyle())       // Simplifies the List style
                    .listRowSeparator(.hidden)         // Removes row separators from the entire list
                    .scrollContentBackground(.hidden)  // Removes the list's scroll background
                }
                .background(Color(UIColor.systemBackground).cornerRadius(20))
            }
                .frame(height: 230)
                .cornerRadius(20)
        } customize: {
            $0.isOpaque(true)
                .type(.toast)
                .position(.bottom)
                .animation(.spring(blendDuration: 0.2))
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
    }

    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Note.order, ascending: true)]
        
        // Update predicate based on the selected filter
        let isCompletedValue = (selectedFilter == .finished)
        fetchRequest.predicate = NSPredicate(format: "listid == %@ AND isCompleted == %@", selectedLists.listid?.uuidString ?? "default", NSNumber(value: isCompletedValue))

        do {
            notes = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }

    private func moveItem(from source: IndexSet, to destination: Int) {
        var revisedItems = notes.map { $0 }
        revisedItems.move(fromOffsets: source, toOffset: destination)
        for (index, note) in revisedItems.enumerated() {
            note.order = Int64(index)
        }
        do {
            try viewContext.save()
        } catch {
            print("Failed to save reordered items: \(error)")
        }
    }

    fileprivate func dismissKeyboardAndTapGesture() {
        keyboardFocused.toggle()
        addTapped.toggle()
    }

    private func addNewNote(withNoteContent: String,dueDate:Date,remindAt:Date) {
        withAnimation {
            let newItem = Note(context: viewContext)
            newItem.listid = selectedLists.listid
            newItem.notename = noteContent
            newItem.isCompleted = false
            newItem.timestamp = Date()
            newItem.duedate = dueDate
            newItem.reminddate = remindAt
            newItem.order = Int64(notes.count)
            do {
                try viewContext.save()
                Utilities.shared.scheduleLocalNotification(for: newItem)
                fetchNotes() // Refresh the notes after adding a new one
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
