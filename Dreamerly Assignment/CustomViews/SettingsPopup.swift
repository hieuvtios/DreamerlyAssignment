//
//  SettingsView.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/10/24.
//

import SwiftUI
struct SpacingObject:Hashable,Identifiable{
    let id: Int
    let name:String
    let value:String
}
struct MarginObject:Hashable,Identifiable{
    let id: Int
    let name:String
    let value:String
}
struct TView: View {
    let tColor: Color
    let colorString: String
    var onTap: ((Bool) -> Void)?
    @State private var isTapped = false

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 45, height: 45)
                .foregroundColor(Color(hex: colorString))
                .overlay(
                                    Circle()
                                        .strokeBorder(isTapped ? Color.red : Color.clear, lineWidth: 1)
                                )
            Text("T")
                .font(.body)
                .foregroundColor(tColor)

        }
        .onTapGesture {
            onTap?(true)
//            isTapped.toggle()

        }
    }
}
struct SettingsItem : Identifiable{
    let id = UUID() // Unique identifier for each item
    let iconName: String
    let type: settingsType
    let settingsText: String
}
enum settingsType {
    case changeName
    case edit
    case sort
    case changeTheme
    case deleteList
}
struct SettingsPopup: View {
    @State var color: Color
    // init settings
    let settingsOptions: [SettingsItem] = [
//        SettingsItem(iconName: "pencil", type: .changeName, settingsText: "Change Name"),
//        SettingsItem(iconName: "square.and.pencil", type: .edit, settingsText: "Edit"),
//        SettingsItem(iconName: "arrow.up.arrow.down", type: .sort, settingsText: "Sort"),
        SettingsItem(iconName: "paintbrush", type: .changeTheme, settingsText: "Change Theme"),
        SettingsItem(iconName: "trash", type: .deleteList, settingsText: "Delete List")
    ]
    
    var body: some View {
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
    }
}


#Preview(body: {
    SettingsPopup(color: Color.blue)
})
