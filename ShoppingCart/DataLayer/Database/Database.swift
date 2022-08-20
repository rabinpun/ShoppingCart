//
//  Database.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import Foundation
import CoreData

extension NSManagedObject {
    static var entityName: String { String(describing: self) }
}

protocol DatabaseObject: NSManagedObject, Identifiable {
    associatedtype Object : DatabaseObjectRepresentation
    func createObject() -> Object
}


protocol DatabaseObjectRepresentation {
    associatedtype Entity : DatabaseObject
    
    func updateObject(_ object: Entity)
}

protocol StorageProvider {
    
    func getBgContext() -> NSManagedObjectContext
    func getMainContext() -> NSManagedObjectContext
    
    func create<T: DatabaseObjectRepresentation>(_ object: T)
    func find<T: DatabaseObjectRepresentation>(_ predicate: NSPredicate) -> T?
    func update<T: DatabaseObjectRepresentation>(_ predicate: NSPredicate,_ object: T)
    func delete<T: DatabaseObjectRepresentation>(predicate: NSPredicate, type: T.Type)
}

class Database: NSObject {
    
    /// The name for the DB file
    private var modelName: String
    
    /// The modelurl for DB file
    private var modelURL: URL!
    
    /// The persistent container
    private var persistentContainer: NSPersistentContainer!
    
    /// The main context
    public lazy var mainContext: NSManagedObjectContext = {
        guard let container = persistentContainer else { fatalError("Container not loaded.") }
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    /// The background context
    public lazy var bgContext: NSManagedObjectContext = {
        guard let container = persistentContainer else { fatalError("Container not loaded.") }
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
    
    required init(modalName: String) {
        let modelName = modalName.isEmpty ? "ShoppingCart" : modalName
        self.modelName = modelName
        super.init()
        self.loadDB()
    }
    
    // method to load the database
    private func loadDB() {
        
        /// initialize
        persistentContainer = NSPersistentContainer(name: modelName)
        
        /// set the description
        let sqliteURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(modelName).sqlite")
        let storeDirectory =  sqliteURL
        let description = NSPersistentStoreDescription(url: storeDirectory)
        persistentContainer.persistentStoreDescriptions = [description]
        
        /// load the container
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                assertionFailure("Unable to load persistent container \(error.localizedDescription)")
            } else {
                debugPrint(description)
            }
        }
    }
    
    func saveContext() {
        bgContext.performAndWait {
            if bgContext.hasChanges {
                do {
                    try bgContext.save()
                } catch {
                    debugPrint("Failed to save background context : \(error)")
                }
                
            }
        }
    }
    
}

extension Database: StorageProvider {
    
    func getBgContext() -> NSManagedObjectContext {
        bgContext
    }
    
    func getMainContext() -> NSManagedObjectContext {
        mainContext
    }
    
    func create<T>(_ object: T) where T : DatabaseObjectRepresentation {
        let dbObject = T.Entity(entity:  NSEntityDescription.entity(forEntityName: T.Entity.entityName, in: bgContext)!, insertInto: bgContext)
        object.updateObject(dbObject)
        saveContext()
    }
    
    func find<T>(_ predicate: NSPredicate) -> T? where T : DatabaseObjectRepresentation {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        guard let result = try? bgContext.fetch(request) as? [T.Entity], let dbObject = result.first else { return nil }
        return dbObject.createObject() as? T
    }
    
    func update<T>(_ predicate: NSPredicate, _ object: T) where T : DatabaseObjectRepresentation {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate =  predicate
        guard let result = try? bgContext.fetch(request) as? [T.Entity], let dbObject = result.first else { return }
        object.updateObject(dbObject)
        saveContext()
    }
    
    func delete<T>(predicate: NSPredicate, type: T.Type) where T : DatabaseObjectRepresentation {
        bgContext.perform { [unowned self] in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
            request.returnsObjectsAsFaults = false
            request.predicate = predicate
            guard let result = try? self.bgContext.fetch(request) as? [T.Entity], let dbObject = result.first else { return }
            self.bgContext.delete(dbObject)
            self.saveContext()
        }
    }
    
}
