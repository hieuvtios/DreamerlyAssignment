//
//  AddListPopup.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/12/24.
//

import SwiftUI

struct ListItem {
    var textContent: String
    var color: Color
    var tagColor: Color
}

struct AddListPopup: View {
    @State var textContent = ""
    @State var color: Color
    @State var tagColor: Color
    @State private var listItem = ListItem(textContent: "", color: .clear, tagColor: .clear)
    @State private var showAlert = false

    // add a string callback
    var doSomething: (ListItem) -> ()
    // init settings
    let settingsOptions: [SettingsItem] = [
        SettingsItem(iconName: "pencil", type: .changeName, settingsText: "Change Name"),
        SettingsItem(iconName: "square.and.pencil", type: .edit, settingsText: "Edit"),
        SettingsItem(iconName: "arrow.up.arrow.down", type: .sort, settingsText: "Sort"),
        SettingsItem(iconName: "paintbrush", type: .changeTheme, settingsText: "Change Theme"),
        SettingsItem(iconName: "trash", type: .deleteList, settingsText: "Delete List")
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Spacer().frame(height: 5)
                Rectangle().frame(width: 30,height: 4).foregroundColor(.secondary).cornerRadius(2, corners: .allCorners)
                HStack(alignment: .center) {
                    Button(action: {
                        // Action here
                    }, label: {
                        Text("Done")
                    }).opacity(0).disabled(true)
                    Spacer()
                    Text("Add new list")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        if(textContent.count == 0){
                            showAlert.toggle()
                            return
                        }
                        listItem = ListItem(textContent: textContent, color: color, tagColor: tagColor)
                        doSomething(listItem)
                        // Action here
                    }, label: {
                        Text("Done")
                            .foregroundStyle(.primary)
                    })
                }.padding()
                .frame(maxWidth: .infinity)
                List {
                    TextField("Add a list name",
                              text: $textContent)
                    ColorPicker("List background color",selection: $color)
                        .font(.caption)
                    ColorPicker("Tag", selection: $tagColor)
                        .font(.caption)

                }
                .onChange(of: color) {  newValue in
                    color = newValue
                    print("color changed to \(newValue.toHex() ?? "")")
                }
                .onChange(of: tagColor) {  newValue in
                    tagColor = newValue
                    print("tag color changed to \(newValue.toHex() ?? "")")
                }
                .scrollDisabled(true)
                .listStyle(PlainListStyle())       // Simplifies the List style
                .listRowSeparator(.hidden)         // Removes row separators from the entire list
                .scrollContentBackground(.hidden)  // Removes the list's scroll background
            }
            .background(Color(UIColor.systemBackground).cornerRadius(20))
            .alert(isPresented: $showAlert) {
                     Alert(
                         title: Text("Input Required"),
                         message: Text("Please enter a name for the list."),
                         dismissButton: .default(Text("OK"))
                     )
                 }
        }
    }
}


