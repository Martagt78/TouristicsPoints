//
//  MyPersistentContainer.swift
//  TouristicPoints
//
//  Created by Marta García on 14/7/21.
//

import Foundation
import CoreData


public class MyPersistentContainer {
    
    public static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
    }
    
    public static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TouristicPoints")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public static func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


