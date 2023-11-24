import SwiftUI
import CoreData

struct StreakView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfMonth as CVarArg,
            Date().endOfMonth as CVarArg))
    private var days: FetchedResults<Day>
    
    @State private var streakValue = 0
    var body: some View {
        VStack {
            Text("\(streakValue)")
                .font(.system(size: 200, weight: .semibold, design: .rounded))
                .foregroundStyle(streakValue > 0 ? .orange : .pink)
            Text("Current Streak")
                .font(.title2)
                .bold()
                .foregroundStyle(.secondary)
        }
        .offset(y: -50)
        .onAppear {
            streakValue = calculateStreakValue()
        }
    }
    
    func calculateStreakValue() -> Int {
        guard !days.isEmpty else { return 0 }
        
        let nonFutureDays = days.filter { $0.date!.dayInt <= Date().dayInt }
        var streakCount = 0
        
        for day in nonFutureDays.reversed() {
            if day.didStudy {
                streakCount += 1
            } else {
                if day.date!.dayInt != Date().dayInt {
                    break
                }
            }
        }
        return streakCount
    }
}

#Preview {
    StreakView()
}
