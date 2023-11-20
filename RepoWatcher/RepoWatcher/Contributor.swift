import Foundation

struct Contributor: Identifiable {
    var id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data
}

extension Contributor {
    struct CodingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int
        
        var contributor: Contributor {
            Contributor(login: login,
                        avatarUrl: avatarUrl,
                        contributions: contributions,
                        avatarData: Data())
        }
    }
}
