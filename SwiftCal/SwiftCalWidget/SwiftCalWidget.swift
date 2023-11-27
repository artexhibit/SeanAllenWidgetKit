import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), days: [])
    }
    
    @MainActor func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let entry = CalendarEntry(date: Date(), days: fetchDays())
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = CalendarEntry(date: Date(), days: fetchDays())
        let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
        completion(timeline)
    }
    
    @MainActor func fetchDays() -> [Day] {
        var sharedStoreURL: URL {
            let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.igorcodes.SwiftCal")!
            return container.appending(path: "SwiftCal.sqlite")
        }
        
        let container: ModelContainer = {
            let config = ModelConfiguration(url: sharedStoreURL)
            return try! ModelContainer(for: Day.self, configurations: config)
        }()
        
        let startDate = Date().startOfCalendarWithPrefixDays
        let endDate = Date().endOfMonth
        
        let predicate = #Predicate<Day> { $0.date > startDate && $0.date < endDate }
        let descriptor = FetchDescriptor<Day>(predicate: predicate, sortBy: [.init(\Day.date)])
        
        return try! container.mainContext.fetch(descriptor)
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let days: [Day]
}

struct SwiftCalWidgetEntryView : View {
    var entry: CalendarEntry
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        HStack {
            Link(destination: URL(string: "streak")!) {
                VStack {
                    Text("\(StreaksCalculator.calculateStreakValue(for: entry.days))")
                        .font(.system(size: 70, design: .rounded))
                        .bold()
                        .foregroundStyle(.orange)
                    Text("day streak")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Link(destination: URL(string: "calendar")!) {
                VStack(spacing: 10) {
                    CalendarHeaderView(font: .caption)
                    
                    LazyVGrid(columns: columns, spacing: 11) {
                        ForEach(entry.days) { day in
                            if day.date.monthInt != Date().monthInt {
                                Text(" ")
                            } else {
                                Text(day.date.formatted(.dateTime.day()))
                                    .font(.caption2)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(day.didStudy ? .orange : .secondary)
                                    .background(
                                        Circle()
                                            .foregroundStyle(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                                            .scaleEffect(1.5)
                                            .scaleEffect(x: 1.1, y: 1.1)
                                    )
                            }
                        }
                    }
                }
            }
            .padding(.leading, 6)
        }
    }
}

struct SwiftCalWidget: Widget {
    let kind: String = "SwiftCalWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SwiftCalWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SwiftCalWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Swift Study Calendar")
        .description("Track Days you study Swift with streaks.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SwiftCalWidget()
} timeline: {
    CalendarEntry(date: .now, days: [])
}
