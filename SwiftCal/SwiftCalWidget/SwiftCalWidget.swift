import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

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
        
        let startDate = Date().startOfCalendarWithPrefixDays
        let endDate = Date().endOfMonth
        
        let predicate = #Predicate<Day> { $0.date > startDate && $0.date < endDate }
        let descriptor = FetchDescriptor<Day>(predicate: predicate, sortBy: [.init(\Day.date)])
        
        let context = ModelContext(Persistense.container)
        return try! context.fetch(descriptor)
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let days: [Day]
}

struct SwiftCalWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CalendarEntry
    
    var body: some View {
        switch family {
        case .systemMedium:
            MeduimCalendarView(entry: entry, streakValue: StreaksCalculator.calculateStreakValue(for: entry.days))
        case .systemSmall, .systemLarge, .systemExtraLarge:
            EmptyView()
        case .accessoryCircular:
            LockScreenCircular(entry: entry)
        case .accessoryRectangular:
            LockScreenRectangularView(entry: entry)
        case .accessoryInline:
            HStack {
                Text("Streak \(StreaksCalculator.calculateStreakValue(for: entry.days)) days")
                Image(systemName: "swift")
            }
            .widgetURL(URL(string: "streak"))
        @unknown default:
            EmptyView()
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
        .supportedFamilies([.systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

#Preview(as: .accessoryCircular) {
    SwiftCalWidget()
} timeline: {
    CalendarEntry(date: .now, days: [])
}

//MARK: - UI Components fro widget sizes

private struct MeduimCalendarView: View {
    var entry: CalendarEntry
    var streakValue: Int
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var today: Day {
        entry.days.filter { Calendar.current.isDate($0.date, inSameDayAs: .now) }.first ?? .init(date: .distantPast, didStudy: false)
    }
    
    var body: some View {
        HStack {
            VStack {
                Link(destination: URL(string: "streak")!) {
                    VStack {
                        Text("\(streakValue)")
                            .font(.system(size: 70, design: .rounded))
                            .bold()
                            .foregroundStyle(.orange)
                            .contentTransition(.numericText())
                        
                        Text("day streak")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Button(today.didStudy ? "Studied" : "Study",
                       systemImage: today.didStudy ? "checkmark.circle" : "book",
                       intent: ToggleStudyIntent(date: today.date))
                .font(.caption2)
                .tint(today.didStudy ? .mint : .orange)
                .controlSize(.small)
            }
            .frame(width: 90)
            
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

private struct LockScreenCircular: View {
    var entry: CalendarEntry
    
    var currentCalendarDays: Int {
        entry.days.filter { $0.date.monthInt == Date().monthInt }.count
    }
    
    var daysStudied: Int {
        entry.days.filter { $0.date.monthInt == Date().monthInt }.filter { $0.didStudy }.count
    }
    
    var body: some View {
        Gauge(
            value: Double(daysStudied),
            in: 1...Double(currentCalendarDays),
            label: {
                Image(systemName: "swift")
            },
            currentValueLabel: {
                Text("\(daysStudied)")
            }
        )
        .gaugeStyle(.accessoryCircular)
    }
}

private struct LockScreenRectangularView: View {
    var entry: CalendarEntry
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var today: Day {
        entry.days.filter { Calendar.current.isDate($0.date, inSameDayAs: .now) }.first ?? .init(date: .distantPast, didStudy: false)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(entry.days) { day in
                if day.date.monthInt != Date().monthInt {
                    Text(" ")
                        .font(.system(size: 10))
                } else {
                    if  day.didStudy {
                        Image(systemName: "swift")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10, height: 10)
                    } else {
                        Text(day.date.formatted(.dateTime.day()))
                            .font(.system(size: 10))
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}
