//
//  CalendarView.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/14/24.
//

import SwiftUI

struct CalendarView: View {
    @State var currentDate: Date
    var body: some View {
        VStack(spacing:50){
            CustomDatePicker(currentDate:$currentDate)
                .navigationTitle("Calendar")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CalendarView(currentDate: Date())
}
