import Foundation

struct MockData {
    static let repoOne = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 65,
                                    watchers: 123,
                                    openIssues: 55,
                                    pushedAt: "2023-11-18T10:38:49Z",
                                    avatarData: Data(),
                                    contributors: [Contributor(login: "Sean Allen", avatarUrl: "", contributions: 42, avatarData: Data()),
                                                   Contributor(login: "Igor Volkov", avatarUrl: "", contributions: 402, avatarData: Data()),
                                                   Contributor(login: "Bill Gates", avatarUrl: "", contributions: 2, avatarData: Data()),
                                                   Contributor(login: "Harvey Spector", avatarUrl: "", contributions: 2, avatarData: Data())
                                                  ])
    
    static let repoOneV2 = Repository(name: "Repository 1",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: true,
                                        forks: 650,
                                        watchers: 450,
                                        openIssues: 5,
                                        pushedAt: "2023-05-18T10:38:49Z",
                                        avatarData: Data(),
                                        contributors: [Contributor(login: "Sean Allen", avatarUrl: "", contributions: 82, avatarData: Data()),
                                                       Contributor(login: "Igor Volkov", avatarUrl: "", contributions: 4002, avatarData: Data()),
                                                       Contributor(login: "Bill Gates", avatarUrl: "", contributions: 200, avatarData: Data()),
                                                       Contributor(login: "Harvey Spector", avatarUrl: "", contributions: 90, avatarData: Data())
                                                      ])
    static let repoTwo = Repository(name: "Repository 2",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: false,
                                    forks: 134,
                                    watchers: 900,
                                    openIssues: 434,
                                    pushedAt: "2022-11-18T10:38:49Z",
                                    avatarData: Data())
}
