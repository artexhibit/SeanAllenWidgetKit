import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct SwiftCalWidgetEntryView : View {
    var entry: Provider.Entry
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        HStack {
            VStack {
                Text("31")
                    .font(.system(size: 70, design: .rounded))
                    .bold()
                    .foregroundStyle(.orange)
                Text("day streak")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 10) {
                CalendarHeaderView(font: .caption)
                
                LazyVGrid(columns: columns, spacing: 11) {
                    ForEach(0..<31) { number in
                        Text("30")
                            .font(.caption2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(number % 7 >= 5 ? .tertiary : .secondary)
                            .background(
                                Circle()
                                    .foregroundStyle(.orange.opacity(0.3))
                                    .scaleEffect(1.5)
                                    .scaleEffect(x: 1.1, y: 1.1)
                            )
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SwiftCalWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}
