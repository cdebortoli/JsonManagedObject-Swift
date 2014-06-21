//
//  JMOWrapper.swift
//  JsonManagedObject
//
//  Created by christophe on 18/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

@objc(JMOWrapper) class JMOWrapper : NSObject {
    
    var childrenClassReference:AnyClass?
    
    func setParameter(jmoParameter:AnyObject, fromJson jsonDict:Dictionary<String, AnyObject>)
    {
        if let parameter = jmoParameter as? JMOConfigModel.JMOParameterModel {
            
            if jsonDict[parameter.jsonKey] != nil {
//                                if let objectValue : AnyObject = getValue(parameter, fromJson: jsonDict) {
                //                    setValue(objectValue, forKey: parameter.attribute)
//                                }
            }
        }
    }
    
    func getValue(jmoParameter:JMOConfigModel.JMOParameterModel, fromJson jsonDict:Dictionary<String, AnyObject>) -> AnyObject? {
        
        var propertyOptional:objc_property_t? = nil
        if let childrenClass:AnyClass = childrenClassReference {
            //            propertyOptional = class_getProperty(childrenClass, parameter.attribute.bridgeToObjectiveC().UTF8String) as objc_property_t?
            //            propertyOptional = ClassFactory.getPropertyFor(childrenClass, andPropertyName: parameter.attribute)
        }
        
        if let property = propertyOptional {
            var x = property_getAttributes(property)
            let propertyType = String.fromCString(property_getAttributes(property))
            let propertyKey = String.fromCString(property_getName(property))
            
            let jsonStringOptional = jsonDict[jmoParameter.jsonKey]! as? String
            if let jsonString = jsonStringOptional {
                switch(propertyType.substringFromIndex(1)) {
                case "f":
                    println("\(propertyKey) is f")
                    return nil
                case "i":
                    println("\(propertyKey) is i")
                    return nil
                case "d":
                    println("\(propertyKey) is d")
                    return nil
                case "c":
                    println("\(propertyKey) is c")
                    return nil
                case "@":
                    println("\(propertyKey) is @")
                    return nil
                default:
                    return nil
                }
            }
        }
        
        
        return nil
    }
}
