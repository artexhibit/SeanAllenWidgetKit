import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let databaseName = "SwiftCal.sqlite"
    
    var oldStoreURL: URL {
        .applicationSupportDirectory.appending(path: databaseName)
    }
    
    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ru.igorcodes.SwiftCal")!
        return container.appending(path: databaseName)
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let startDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
        
        for dayOffset in 0..<30 {
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)
            newDay.didStudy = Bool.random()
            
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftCal")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else if !FileManager.default.fileExists(atPath: oldStoreURL.path) {
            print("Old store doesnt exist, using new shared URL")
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }
        
        print("Container URL equals: \(container.persistentStoreDescriptions.first!.url!)")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        let coordinator = container.persistentStoreCoordinator
        print("Went into migrateStore")
        
        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else { return }
        print("Old store no longer exists")
        
        do {
           let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            print("Migration succsessful")
        } catch {
            fatalError("Unable to migrate to shared store")
        }
        
        do {
            try FileManager.default.removeItem(at: oldStoreURL)
            print("Old store deleted")
        } catch {
            print("Unable to delete the old store")
        }
    }
}
