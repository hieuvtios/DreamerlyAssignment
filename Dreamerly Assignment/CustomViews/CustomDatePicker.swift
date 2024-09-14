import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    @State private var currentMonth: Int = 0
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.duedate, ascending: true)],
        animation: .default
    ) private var notes: FetchedResults<Note> // Fetch Notes from Core Data


    var body: some View {
        ScrollView{
            VStack(spacing: 35) {
                let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(extraDate()[0])
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(extraDate()[1])
                            .font(.title.bold())
                    }
                    Spacer(minLength: 0)
                    Button(action: {
                        withAnimation {
                            currentMonth -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                    Button(action: {
                        withAnimation {
                            currentMonth += 1
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(extractDate()) { value in
                        CardView(value: value)
                            .background(
                                Capsule().fill(Color.green.opacity(0.7))
                                    .padding(.horizontal,8)
                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            )
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
                VStack(spacing: 20){
                    Text("Tasks")
                        .font(.title2.bold())
                        .frame(maxWidth:.infinity,alignment: .leading)
                        .padding(.vertical,20)
                    // Filter notes for the selected date
                                     let filteredNotes = notes.filter { note in
                                         isSameDay(date1: note.duedate ?? Date(), date2: currentDate)
                                     }
                    if filteredNotes.isEmpty {
                                         Text("No Task Found")
                                     } else {
                                         ForEach(filteredNotes, id: \.self) { note in
                                             VStack(alignment: .leading, spacing: 10) {
                                                 Text(note.duedate ?? Date(), style: .time)
                                                 Text(note.notename ?? "")
                                                     .font(.title2.bold())
                                             }
                                             .padding(.vertical, 10)
                                             .padding(.horizontal)
                                             .frame(maxWidth: .infinity, alignment: .leading)
                                             .background(
                                                 Color.green
                                                     .opacity(0.5)
                                                     .cornerRadius(10)
                                             )
                                         }
                                     }
//                    if let tasks = tasks.first(where: { task in
//                        return isSameDay(date1: task.taskDate, date2: currentDate)
//                    }){
//                        ForEach(tasks.task){task in
//                            VStack(alignment: .leading,spacing:10){
//                                Text(task.time
//                                    .addingTimeInterval(CGFloat.random(in: 0...5000)),style: .time)
//                                Text(task.title)
//                                    .font(.title2.bold())
//                                
//                            }
//                            .padding(.vertical,10)
//                            .padding(.horizontal)
//                            .frame(maxWidth: .infinity,alignment: .leading)
//                            .background(
//                                Color.purple
//                                    .opacity(0.5)
//                                    .cornerRadius(10)
//                            )
//                        }
//                    }else{
//                        Text("No Task Found")
//                    }
                }
                .padding()
                .padding(.top,20)
            }
            .onChange(of: currentMonth) { newValue in
                currentDate = getCurrentMonth()
            }
        }
    }
    @ViewBuilder
       func CardView(value: DateValue) -> some View {
           VStack {
               if value.day != -1 {
                   let hasDueDate = notes.contains { note in
                       isSameDay(date1: note.duedate ?? Date(), date2: value.date)
                   }

                   Text("\(value.day)")
                       .font(.title3.bold())
                       .foregroundColor(hasDueDate ? .blue : .primary)
                       .frame(maxWidth: .infinity)

                   Spacer()

                   if hasDueDate {
                       Circle()
                           .fill(Color.white)
                           .frame(width: 8, height: 8)
                   }
               }
           }
           .padding(.vertical, 8)
           .frame(height: 60, alignment: .top)
       }
    //checking date
    func isSameDay(date1: Date,date2: Date) -> Bool{
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: getCurrentMonth())
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        // adding offset day to get extract week day
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekDay - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
            
        }
        return days
    }
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        var range = calendar.range(of: .day, in: .month, for: startDate)!
//        range.removeLast()
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
    
}
  
struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(currentDate: .constant(Date()))
    }
}
