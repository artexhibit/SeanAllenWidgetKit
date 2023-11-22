import WidgetKit
import SwiftUI

struct DoubleRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> DoubleRepoEntry {
        DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DoubleRepoEntry) -> ()) {
        let entry = DoubleRepoEntry(date: Date(), topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        //using Task coz we have an async/await network call and should be in async context
        Task {
            let nexUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                // Get Top Repo
                var repo = try await NetworkManager.shared.getRepo(atURL: RepoURL.kursvalut)
                let topAvatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = topAvatarImageData ?? Data()
                
                //Get Bottom Repo
                var bottomRepo = try await NetworkManager.shared.getRepo(atURL: RepoURL.react)
                let bottomAvatarImageData = await NetworkManager.shared.downloadImageData(from: bottomRepo.owner.avatarUrl)
                bottomRepo.avatarData = bottomAvatarImageData ?? Data()
                
                //Create Entry and Timeline
                let entry = DoubleRepoEntry(date: .now, topRepo: repo, bottomRepo: bottomRepo)
                //request widget update each 12 hours from now
                let timeline = Timeline(entries: [entry], policy: .after(nexUpdate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error)")
            }
        }
    }
}

struct DoubleRepoEntry: TimelineEntry {
    let date: Date
    let topRepo: Repository
    let bottomRepo: Repository
}

struct DoubleRepoEntryView : View {
    var entry: DoubleRepoEntry
    
    var body: some View {
        VStack(spacing: 45) {
            RepoMediumView(repo: entry.topRepo)
            RepoMediumView(repo: entry.bottomRepo)
        }
    }
}

struct DoubleRepoWidget: Widget {
    let kind: String = "DoubleRepoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DoubleRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                DoubleRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DoubleRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on two GitHub repos.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    DoubleRepoWidget()
} timeline: {
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    DoubleRepoEntry(date: .now, topRepo: MockData.repoOneV2, bottomRepo: MockData.repoTwo)
}
