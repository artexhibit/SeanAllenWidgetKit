import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(atURL urlString: String) async throws -> Repository {
        //create a valid url
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidRepoURL
        }
        
        //do a URLSession to receive data and responce
        let (data, responce) = try await URLSession.shared.data(from: url)
        
        //check if responce is valid
        guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
            throw NetworkError.invalidResponce
        }
        
        //decoding the data
        do {
            let codingData = try decoder.decode(Repository.CodingData.self, from: data)
            return codingData.repo
        } catch {
            throw NetworkError.invalidRepoData
        }
    }
    
    func getContributors(atURL urlString: String) async throws -> [Contributor] {
            //create a valid url
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidRepoURL
            }
            
            //do a URLSession to receive data and responce
            let (data, responce) = try await URLSession.shared.data(from: url)
            
            //check if responce is valid
            guard let responce = responce as? HTTPURLResponse, responce.statusCode == 200 else {
                throw NetworkError.invalidResponce
            }
            
            //decoding the data
            do {
                let codingData = try decoder.decode([Contributor.CodingData].self, from: data)
                return codingData.map { $0.contributor }
            } catch {
                throw NetworkError.invalidRepoData
            }
        }
    
    func downloadImageData(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }
}

enum NetworkError: Error {
    case invalidRepoURL
    case invalidResponce
    case invalidRepoData
}

enum RepoURL {
    static let prefix = "https://api.github.com/repos/"
    static let kursvalut = "https://api.github.com/repos/artexhibit/Kursvalut"
    static let seanAllenWidgetKit = "https://api.github.com/repos/artexhibit/SeanAllenWidgetKit"
    static let react = "https://api.github.com/repos/facebook/react"
}
