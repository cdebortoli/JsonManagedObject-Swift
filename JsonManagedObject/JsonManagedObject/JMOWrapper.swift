//
//  JMOWrapper.swift
//  JsonManagedObject
//
//  Created by christophe on 18/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

@objc(JMOWrapper) public class JMOWrapper : NSObject {
    
    internal var childrenClassReference:AnyClass?
    
    internal func setParameter(jmoParameter:AnyObject, fromJson jsonDict:[String: AnyObject])
    {
        if let parameter = jmoParameter as? JMOConfigModel.JMOParameterModel {
            
            if jsonDict[parameter.jsonKey] != nil {
                if let objectValue : AnyObject = getValue(parameter, fromJson: jsonDict) {
                    setValue(objectValue, forKey: parameter.attribute)
                }
            }
        }
    }
    
//    TODO : see reflect method
// Note : Cast anyClass to nsobject.Type to be able to init it
//var clz: NSObject.Type = myAnyClass as NSObject.Type
    internal func getValue(jmoParameter:JMOConfigModel.JMOParameterModel, fromJson jsonDict:[String: AnyObject]) -> AnyObject? {
        
        var propertyOptional:objc_property_t? = nil
        if let childrenClass:AnyClass = childrenClassReference {
                        propertyOptional = class_getProperty(childrenClass, jmoParameter.attribute) as objc_property_t?
//                        propertyOptional = ClassFactory.getPropertyFor(childrenClass, andPropertyName: parameter.attribute)
        }
        println(propertyOptional)
        if let property = propertyOptional {
            var x = property_getAttributes(property)
            let propertyTypeOptional = String.fromCString(property_getAttributes(property))
            let propertyKeyOptional = String.fromCString(property_getName(property))
            
            let jsonStringOptional = jsonDict[jmoParameter.jsonKey]! as? String
            switch (propertyTypeOptional, propertyKeyOptional, jsonStringOptional) {
            case (.Some(let propertyType), .Some(let propertyKey), .Some(let jsonString)):
                switch(propertyType.substringFromIndex(advance(propertyType.startIndex, 1))) {
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
            default:
                return nil
            }
        }
        
        
        return nil
    }
}
