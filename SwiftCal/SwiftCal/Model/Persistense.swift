import Foundation
import SwiftData

struct Persistense {
    static var container: ModelContainer {
        let container: ModelContainer = {
            let sharedStoreURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.igorcodes.SwiftCal")!.appending(path: "SwiftCal.sqlite")
            let config = ModelConfiguration(url: sharedStoreURL)
            
            return try! ModelContainer(for: Day.self, configurations: config)
        }()
        
        return container
    }
}
