import SwiftUI
import Charts
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var totalTasks: Int = 0
    @State private var completedTasks: Int = 0
    @State private var pendingTasks: Int = 0

    var body: some View {
        VStack {
            HStack {
                StatisticCardView(title: "Total Tasks", count: totalTasks, color: .blue)
                StatisticCardView(title: "Completed", count: completedTasks, color: .green)
                StatisticCardView(title: "Pending", count: pendingTasks, color: .red)
            }
            .padding()

            // Pie chart for task statistics
            if totalTasks > 0 {
                
                PieChartView(completedTasks: completedTasks, pendingTasks: pendingTasks)
                    .frame(height: 200)
                    .padding()
                VStack(alignment:.leading){
                    HStack{
                        Rectangle().foregroundColor(.green).frame(width: 10,height: 10)
                        Text("Completed tasks")
                            .font(.footnote)
                    }
                    HStack{
                        Rectangle().foregroundColor(.red).frame(width: 10,height: 10)
                        Text("Pending tasks")
                            .font(.footnote)
                    }
                }
            } else {
                Text("No tasks available")
                    .font(.headline)
                    .padding(.top, 50)
            }

            Spacer()
                .navigationTitle("Dashboard")
        }
        .padding()
        .onAppear {
            fetchTaskStatistics() // Fetch task statistics when the view appears
        }
    }
    
    // Fetch task statistics from Core Data
    private func fetchTaskStatistics() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()

        do {
            let allNotes = try viewContext.fetch(fetchRequest)
            totalTasks = allNotes.count
            completedTasks = allNotes.filter { $0.isCompleted }.count
            pendingTasks = totalTasks - completedTasks
        } catch {
            print("Failed to fetch task statistics: \(error)")
        }
    }
}

// Pie Chart View
struct PieChartView: View {
    var completedTasks: Int
    var pendingTasks: Int

    var body: some View {
        let taskData = [
            TaskStatistic(name: "Completed", count: completedTasks, color: .green),
            TaskStatistic(name: "Pending", count: pendingTasks, color: .red)
        ]

        Chart(taskData) { task in
            if #available(iOS 17.0, *) {
                SectorMark(
                    angle: .value("Task Count", task.count)
//                    innerRadius: .ratio(0.5),
//                    angularInset: 2
                )
                .foregroundStyle(task.color)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// Data model for task statistics
struct TaskStatistic: Identifiable {
    var id = UUID()
    var name: String
    var count: Int
    var color: Color
}

// Subview for individual statistic cards
struct StatisticCardView: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text("\(count)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(color)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
