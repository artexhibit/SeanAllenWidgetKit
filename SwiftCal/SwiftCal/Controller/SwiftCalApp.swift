import SwiftUI
import SwiftData

@main
struct SwiftCalApp: App {
    @State private var selectedTab = 0
    
    static var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.igorcodes.SwiftCal")!
        return container.appending(path: "SwiftCal.sqlite")
    }
    
    let container: ModelContainer = {
        let config = ModelConfiguration(url: sharedStoreURL)
        return try! ModelContainer(for: Day.self, configurations: config)
    }()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                CalendarView()
                    .tabItem { Label("Calendar", systemImage: "calendar") }
                    .tag(0)
                StreakView()
                    .tabItem { Label("Streak", systemImage: "swift") }
                    .tag(1)
            }
            .modelContainer(container)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "calendar" ? 0 : 1
            }
        }
    }
}
