//
//  DatabaseCode.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import CoreData

class DatabaseCore {
    func saveContext () {
        var error: NSError? = nil
        let managedObjectContext = self.managedObjectContext
        if managedObjectContext != nil {
            if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    
    var managedObjectContext: NSManagedObjectContext {
        if !_managedObjectContext {
            let coordinator = self.persistentStoreCoordinator
            if coordinator != nil {
                _managedObjectContext = NSManagedObjectContext()
                _managedObjectContext!.persistentStoreCoordinator = coordinator
            }
            }
            return _managedObjectContext!
        }
    var _managedObjectContext: NSManagedObjectContext? = nil
    
    var managedObjectModel: NSManagedObjectModel {
        if !_managedObjectModel {
            let modelURL = NSBundle.mainBundle().URLForResource("JMODemo", withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
            }
            return _managedObjectModel!
        }
    var _managedObjectModel: NSManagedObjectModel? = nil
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        if !_persistentStoreCoordinator {
            let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("JMODemo.sqlite")
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if _persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
                /*
                Replace this implementation with code to handle the error appropriately.
                
                abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                Typical reasons for an error here include:
                * The persistent store is not accessible;
                * The schema for the persistent store is incompatible with current managed object model.
                Check the error message to determine what the actual problem was.
                
                
                If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
                
                If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                * Simply deleting the existing store:
                NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
                
                * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true}
                
                Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
                
                */
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            }
            return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    
    
    var applicationDocumentsDirectory: NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
}
