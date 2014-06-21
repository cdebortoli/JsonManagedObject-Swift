//
//  DatabaseManager.swift
//  EasyJson-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

let databaseManagerSharedInstance = DatabaseManager()

class DatabaseManager {
    let databaseCore = DatabaseCore()

    func saveContext() {
        databaseCore.saveContext()
    }
    
    func rollbackContext() {
        databaseCore.managedObjectContext.rollback()
    }
}