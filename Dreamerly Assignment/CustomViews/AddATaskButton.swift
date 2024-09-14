//
//  AddATaskButton.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/9/24.
//

import SwiftUI

struct AddATaskButton:View {
    @Binding var addTapped: Bool
    var body: some View {
        Button(action: {
            addTapped.toggle()
        }, label: {
            VStack(spacing: 0) {
              HStack(spacing: 12) {
                  Image(systemName: "plus")
                      .foregroundColor(.white)
                Text("Add new Task")
                      .font(.callout)
                  .tracking(0.10)
                  .lineSpacing(20)
                  .foregroundColor(.white)
                  Spacer()
              }
              .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 20))
              .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 54)
            .background(Color.secondary.opacity(0.3))
            .cornerRadius(8)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 3, y: 1
            )
        })
    }
}


#Preview {
    AddATaskButton( addTapped: .constant(true))
}
