//
//  ContentView.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/9/24.
//

import SwiftUI
import CoreData
import PopupView



struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showAddListPopup: Bool = false
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Tasks> // List tags
    @StateObject private var viewModel = ListViewModel() // Model to manage list tasks
    let colorPallets = ["70d6ff","ff70a6","ff9770","ffd670"] // Hex Color for icons in Menu
    @State private var searchText = ""
    @State var selectedLists : Tasks = Tasks()
    @State private var selectedItem: Tasks? // Replace 'YourItemType' with the actual type of 'item'
    @State private var showingFilterOptions = false

    
    
    private var filteredItems: [Tasks] {
        // Filter items based on the search text
        if searchText.isEmpty {
            return Array(items) // Convert FetchedResults to Array to be safely used in filteredItems
        } else {
            return items.filter { item in
                if let noteName = item.taskListName {
                    return noteName.localizedCaseInsensitiveContains(searchText)
                } else {
                    return false
                }
            }
        }
    }
    
    private func menuRow(icon: String, colorIndex: Int, title: String) -> some View {
        menuRow(icon: icon, color: Color(hex: colorPallets[colorIndex]), title: title)
    }
    
    private func menuRow(icon: String, color: Color, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(title)
                .lineLimit(1)
        }
    }
    private var menuSection: some View {
        Section(header: Text("Menu")) {
            NavigationLink(destination: CalendarView(currentDate: Date())) {
                menuRow(icon: "calendar", colorIndex: 0, title: "Calendar")
            }
            NavigationLink(destination: DashboardView()) {
                menuRow(icon: "chart.bar", colorIndex: 2, title: "Dashboard")
            }
//            NavigationLink(destination: Text("Tags")) {
//                menuRow(icon: "tag", colorIndex: 3, title: "Tags")
//            }
        }
    }
    var body: some View {
        NavigationView {
            List {
                
                menuSection
                Section(header: HStack {
                                   Text("Lists")
                                   Spacer()
                }){
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: AddListView( selectedLists: item)) {
                            HStack{
                                Image(systemName: "list.bullet")
                                Text(item.taskListName ?? "")
                                    .lineLimit(1)
                                Spacer()
                                Circle()
                                    .foregroundColor(Color(hex: item.tag ?? ""))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            
            .listStyle(.plain)
            .listRowSeparator(.hidden, edges: .all)
            .searchable(text: $searchText)
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddListPopup.toggle()
                    }, label: {
                        HStack {
                            Text("")
                            HStack(spacing:5){
                                Text("New List")
                                Image(systemName: "plus")
                            }
                        }
                    })
                }
            }
            .popup(isPresented: $showAddListPopup) {
                AddListPopup(color: Color.blue, tagColor: Color.blue, doSomething: {object in
                    showAddListPopup.toggle()
                    viewModel.addList(taskListName: object)
                })
                .frame(height: 250)
                .cornerRadius(20)
                
            } customize: {
                $0.isOpaque(true)
                    .type(.floater(verticalPadding: 2, horizontalPadding: 20, useSafeAreaInset: true))
                    .position(.center)
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
                    .backgroundColor(.black.opacity(0.4))
                    .dismissCallback {
                        
                    }
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredItems[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

#Preview {
    ListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
