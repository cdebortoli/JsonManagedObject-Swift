//
//  JMOConfig.swift
//  JsonManagedObject-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import CoreData

struct JMOConfig {
    static var dateFormat = "yyyy-MM-dd"
    static var jsonWithEnvelope = false
    static var managedObjectContext:NSManagedObjectContext?
    static var temporaryNSManagedObjectInstance = false
}


