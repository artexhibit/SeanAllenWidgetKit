import SwiftUI
import SwiftData
import WidgetKit

struct CalendarView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<Day> { $0.date > startDate && $0.date < endDate }, sort: \Day.date)
    var days: [Day]
    
    static var startDate: Date {
        .now.startOfCalendarWithPrefixDays
    }
    
    static var endDate: Date {
        .now.endOfMonth
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                CalendarHeaderView()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    
                    ForEach(days) { day in
                        if day.date.monthInt != Date().monthInt {
                            Text(" ")
                        } else {
                            Text(day.date.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .foregroundStyle(day.didStudy ? .orange : .secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundStyle(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                                )
                                .onTapGesture {
                                    if day.date.dayInt <= Date().dayInt {
                                        day.didStudy.toggle()
                                        WidgetCenter.shared.reloadTimelines(ofKind: "SwiftCalWidget")
                                    } else {
                                        print("Can's study in the futute!")
                                    }
                                }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
            .onAppear {
                if days.isEmpty {
                    createMonthDate(for: .now.startOfPreviousMonth)
                    createMonthDate(for: .now)
                } else if days.count < 10 { //is this ONLY the prefix days
                    createMonthDate(for: .now)
                }
            }
        }
    }
    
    func createMonthDate(for date: Date) {
        for dayOffset in 0..<date.numberOfDaysInMonth {
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)!
            let newDay = Day(date: date, didStudy: false)
            context.insert(newDay)
        }
    }
}

#Preview {
    CalendarView()
}
