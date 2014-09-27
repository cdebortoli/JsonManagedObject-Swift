//
//  JMOExtension.swift
//  JsonManagedObject
//
//  Created by christophe on 18/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import CoreData
import JsonManagedObject

/*
* JSON -> SWIFT
*/
public extension NSManagedObject {
    
    // Set property value
    internal func setProperty(jmoParameter:JMOParameterModel, fromJson jsonDict:[String: AnyObject]) {
        if jsonDict[jmoParameter.jsonKey] != nil {
            if let managedObjectValue : AnyObject = getValue(jmoParameter, fromJsonDictionary: jsonDict) {
                setValue(managedObjectValue, forKey: jmoParameter.attributeName)
            }
        }
    }
    
    // Get NSPropertyDescription
    internal func getPropertyDescription(jmoParameter:JMOParameterModel) -> NSPropertyDescription? {
        if let propertyDescription = self.entity.propertiesByName[jmoParameter.attributeName] as? NSPropertyDescription {
            return propertyDescription
        }
        return nil
    }
    
    // Retrieve formated property value from json
    internal func getValue(jmoParameter:JMOParameterModel, fromJsonDictionary jsonDict:[String: AnyObject]) -> AnyObject? {
        
        var propertyDescriptionOptional = getPropertyDescription(jmoParameter) as NSPropertyDescription?
        if let propertyDescription = propertyDescriptionOptional {
            if propertyDescription is NSAttributeDescription {

                if let jsonString = jsonDict[jmoParameter.jsonKey]! as? String {
                    return (propertyDescription as NSAttributeDescription).getAttributeValueForJmoJsonValue(jsonString)
                } else if let jsonNumber = jsonDict[jmoParameter.jsonKey]! as? NSNumber {
                    let jsonString = "\(jsonNumber)"
                    return (propertyDescription as NSAttributeDescription).getAttributeValueForJmoJsonValue(jsonString)
                }
                
            } else if propertyDescription is NSRelationshipDescription {

                if let jsonArray = jsonDict[jmoParameter.jsonKey]! as? [[String: AnyObject]] {
                    return (propertyDescription as NSRelationshipDescription).getRelationshipValueForJmoJsonArray(jsonArray)
                } else if let jsonDictRelation = jsonDict[jmoParameter.jsonKey]! as? [String: AnyObject] {
                    return jsonManagedObjectSharedInstance.analyzeJsonDictionary(jsonDictRelation, forClass: NSClassFromString((propertyDescription as NSRelationshipDescription).destinationEntity.managedObjectClassName))
                }
                
            }
        }
        return nil
    }
}

/*
* SWIFT -> JSON
*/
public extension NSManagedObject {

    public func getJson(relationshipClassesToIgnore:[String] = [String]()) -> Dictionary <String, AnyObject>{
        var jsonDict = Dictionary <String, AnyObject>()
        
        var newRelationshipClassesToIgnore = [String]()
        newRelationshipClassesToIgnore += relationshipClassesToIgnore
        newRelationshipClassesToIgnore.append(NSStringFromClass(self.classForCoder))

        if let configObject = jsonManagedObjectSharedInstance.configDatasource[NSStringFromClass(self.classForCoder)] {
            for parameter in configObject.parameters {
                if let managedObjectValue:AnyObject? = self.valueForKey(parameter.attributeName) {
                    
                    if managedObjectValue is NSSet {
                        var relationshipObjects = [AnyObject]()
                        setloop: for objectFromSet:AnyObject in (managedObjectValue as NSSet).allObjects {
                            if (contains(newRelationshipClassesToIgnore, NSStringFromClass(objectFromSet.classForCoder))) {
                                break setloop
                            }
                            relationshipObjects.append((objectFromSet as NSManagedObject).getJson(relationshipClassesToIgnore: newRelationshipClassesToIgnore))
                        }
                        if !relationshipObjects.isEmpty {
                            jsonDict[parameter.jsonKey] = relationshipObjects
                        }
                    
                    } else {
                        jsonDict[parameter.jsonKey] = managedObjectValue
                    }
                }
            }
            
            if JMOConfig.jsonWithEnvelope == true {
                return [configObject.classInfo.jsonKey : jsonDict]
            }
        }
        return jsonDict

    }
}

internal extension NSAttributeDescription {
    internal func getAttributeValueForJmoJsonValue(jsonValue:String) -> AnyObject? {
        switch(self.attributeType){
        case .DateAttributeType:
            return jsonManagedObjectSharedInstance.dateFormatter.dateFromString(jsonValue)
        case .StringAttributeType:
            return jsonValue
        case .DecimalAttributeType,.DoubleAttributeType:
            return NSNumber.numberWithDouble((jsonValue as NSString).doubleValue)
        case .FloatAttributeType:
            return (jsonValue as NSString).floatValue
        case .Integer16AttributeType,.Integer32AttributeType,.Integer64AttributeType:
            return (jsonValue as NSString).integerValue
        case .BooleanAttributeType:
            return (jsonValue as NSString).boolValue
        default:
            return nil
        }
    }
}

internal extension NSRelationshipDescription {
    internal func getRelationshipValueForJmoJsonArray(jsonArray:[[String: AnyObject]]) -> NSMutableSet {
        var relationshipSet = NSMutableSet()
        for jsonValue in jsonArray  {
            if let relationshipObject: AnyObject = jsonManagedObjectSharedInstance.analyzeJsonDictionary(jsonValue, forClass: NSClassFromString(self.destinationEntity.managedObjectClassName)) {
                relationshipSet.addObject(relationshipObject)
            }
        }
        return relationshipSet
    }
}