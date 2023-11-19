import Foundation

struct MockData {
    static let repoOne = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 65,
                                    watchers: 123,
                                    openIssues: 55,
                                    pushedAt: "2023-11-18T10:38:49Z",
                                    avatarData: Data())
    static let repoTwo = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: false,
                                    forks: 134,
                                    watchers: 900,
                                    openIssues: 434,
                                    pushedAt: "2022-11-18T10:38:49Z",
                                    avatarData: Data())
}
