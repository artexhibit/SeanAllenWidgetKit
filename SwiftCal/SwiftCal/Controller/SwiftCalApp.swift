import SwiftUI
import SwiftData

@main
struct SwiftCalApp: App {
    @State private var selectedTab = 0
    
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
            .modelContainer(Persistense.container)
            .onOpenURL { url in
                selectedTab = url.absoluteString == "calendar" ? 0 : 1
            }
        }
    }
}
