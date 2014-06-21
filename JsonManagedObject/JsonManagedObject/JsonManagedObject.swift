//
//  JsonManagedObject.swift
//  JsonManagedObject-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

let jsonManagedObjectSharedInstance = JsonManagedObject()

class JsonManagedObject {
    let dateFormatter = NSDateFormatter()
    @lazy var configDatasource = JMOConfigDatasource()
    
    init() {
        dateFormatter.dateFormat = JMOConfig.dateFormat
    }
    
    // Analyze an array of Dictionary
    func analyzeJsonArray(jsonArray:AnyObject[], forClass objectClass:AnyClass) -> AnyObject[] {
        var resultArray = AnyObject[]()
        for jsonArrayOccurence:AnyObject in jsonArray {
            if let jsonDict = jsonArrayOccurence as? Dictionary<String, AnyObject> {
                if let objectFromJson : AnyObject = analyzeJsonDictionary(jsonDict, forClass: objectClass) {
                    resultArray += objectFromJson
                }
            }
        }
        return resultArray
    }
    
    // Analyze a dDictionary
    func analyzeJsonDictionary(jsonDictionary:Dictionary<String, AnyObject>, forClass objectClass:AnyClass) -> AnyObject? {
        // 1 - Find the config object for the specified class
        let configObjectOptional = configDatasource[NSStringFromClass(objectClass)]
        if let configObject = configObjectOptional {
            
            // 2 - Json Dictionary
            var jsonFormatedDictionary = jsonDictionary
            // Envelope
            if JMOConfig.jsonWithEnvelope {
                if let dictUnwrapped = jsonDictionary[configObject.classInfo.jsonKey]! as? Dictionary<String, AnyObject> {
                    jsonFormatedDictionary = dictUnwrapped
                }
            }
            
            // 3a - NSManagedObject Parse & init
            if class_getSuperclass(objectClass) is NSManagedObject.Type {
                if JMOConfig.managedObjectContext == nil {
                    return nil
                }
                
                var managedObject:NSManagedObject
                if JMOConfig.temporaryNSManagedObjectInstance == false {
                    managedObject = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(objectClass), inManagedObjectContext: JMOConfig.managedObjectContext!) as NSManagedObject
                } else {
                    let entityDescription = NSEntityDescription.entityForName(NSStringFromClass(objectClass), inManagedObjectContext: JMOConfig.managedObjectContext)
                    managedObject = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: nil)
                }
                
                for parameter in configObject.parameters {
                    managedObject.setProperty(parameter, fromJson: jsonFormatedDictionary)
                }
                return managedObject
            // 3b - CustomObject Parse & init
            } else if class_getSuperclass(objectClass) is JMOWrapper.Type {
                var cobject : AnyObject! = JMOClassFactory.initObjectFromClass(objectClass)
                (cobject as JMOWrapper).childrenClassReference = objectClass
                    
                for parameter in configObject.parameters {
                    (cobject as JMOWrapper).setParameter(parameter, fromJson: jsonFormatedDictionary)
                }
            }
        }
        return nil
    }
}
