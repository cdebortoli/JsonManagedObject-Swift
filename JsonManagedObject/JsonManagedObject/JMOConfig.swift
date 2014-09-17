//
//  JMOConfig.swift
//  JsonManagedObject-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import CoreData

public struct JMOConfig {
    public static var dateFormat = "yyyy-MM-dd"
    public static var jsonWithEnvelope = false
    public static var managedObjectContext:NSManagedObjectContext?
    public static var temporaryNSManagedObjectInstance = false
}


