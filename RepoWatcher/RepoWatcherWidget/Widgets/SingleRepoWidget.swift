import SwiftUI
import WidgetKit

struct SingleRepoProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SingleRepoEntry {
        SingleRepoEntry(date: .now, repo: MockData.repoOne)
    }
    
    func snapshot(for configuration: SelectSingleRepo, in context: Context) async -> SingleRepoEntry {
        let entry = SingleRepoEntry(date: .now, repo: MockData.repoOne)
        return entry
    }
    
    func timeline(for configuration: SelectSingleRepo, in context: Context) async -> Timeline<SingleRepoEntry> {
        let nexUpdate = Date().addingTimeInterval(43200)
        
        do {
            //Get Repo
            let repoToShow = RepoURL.prefix + (configuration.repo ?? "")
            var repo = try await NetworkManager.shared.getRepo(atURL: repoToShow)
            let avatarImageData = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
            repo.avatarData = avatarImageData ?? Data()
            
            if context.family == .systemLarge {
                //Get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atURL: repoToShow + "/contributors")
                
                //Filter to top 4 contributors
                var topFour = Array(contributors.prefix(4))
                
                //Dowload top four avatars
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                repo.contributors = topFour
            }
            
            //Create entry and timeline
            let entry = SingleRepoEntry(date: .now, repo: repo)
            let timeline = Timeline(entries: [entry], policy: .after(nexUpdate))
            return timeline
        } catch {
            print("❌ Error - \(error)")
            return Timeline(entries: [], policy: .after(nexUpdate))
        }
    }
}

struct SingleRepoEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct SingleRepoEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: SingleRepoEntry
    
    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack {
                RepoMediumView(repo: entry.repo)
                Spacer().frame(height: 40)
                ContributorMediumView(repo: entry.repo)
            }
        case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

@main
struct SingleRepoWidget: Widget {
    let kind: String = "SingleRepoWidget"
    
    var body: some WidgetConfiguration {
        
        AppIntentConfiguration(kind: kind, intent: SelectSingleRepo.self, provider: SingleRepoProvider()) { entry in
            
            if #available(iOS 17.0, *) {
                SingleRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SingleRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Single Repo")
        .description("Track a single repository.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemLarge) {
    SingleRepoWidget()
} timeline: {
    SingleRepoEntry(date: .now, repo: MockData.repoOne)
    SingleRepoEntry(date: .now, repo: MockData.repoOneV2)
}
