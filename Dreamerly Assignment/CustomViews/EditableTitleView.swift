//
//  EditableView.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/9/24.
//

import SwiftUI

struct EditableTitleView: View {
  @State private var editableTitle: String = "My Title"
    var body: some View {
      NavigationView {
        Text("View with editable title")
          .toolbar {
            ToolbarItem(placement: .principal) {
              TextField("Title", text: $editableTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
          }
      }
    }
}

#Preview {
    EditableTitleView()
}
