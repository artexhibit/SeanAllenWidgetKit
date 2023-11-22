import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.ru.igorcodes.RepoWatcher")!
    }
    
    static let repoKey = "repos"
}

enum UserDefaultError: Error {
    case retrieval
}
