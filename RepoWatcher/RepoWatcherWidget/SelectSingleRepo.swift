import Foundation
import AppIntents

struct SelectSingleRepo: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "SelectSingleRepoIntent"
    
    static var title: LocalizedStringResource = "Select Single Repo"
    static var description = IntentDescription("Choose a repository to watch")
    
    @Parameter(title: "Repo", optionsProvider: RepoOptionsProvider())
    var repo: String?
    
    struct RepoOptionsProvider: DynamicOptionsProvider {
        
        func results() async throws -> [String] {
            guard let repos = UserDefaults.shared.value(forKey: UserDefaults.repoKey) as? [String] else {
                throw UserDefaultError.retrieval
            }
            
            return repos
        }
        
        func defaultResult() async -> String? {
            return "artexhibit/Kursvalut"
        }
    }
}

