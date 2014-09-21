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
                println(parameter.attribute)
                if let objectValue : AnyObject = getValue(parameter, fromJson: jsonDict) {
                    println(objectValue)
                    setValue(objectValue, forKey: parameter.attribute)
                }
            }
        }
    }
    
    internal func getValue(jmoParameter:JMOConfigModel.JMOParameterModel, fromJson jsonDict:[String: AnyObject]) -> AnyObject? {
        
        var jsonStringOptional = jsonDict[jmoParameter.jsonKey]! as? String
        
        println(jsonStringOptional)
        
        if let jsonString = jsonStringOptional {
            let JMOWrapperMirror = reflect(self)
            for var i = 0; i < JMOWrapperMirror.count; i++ {
                let (propertyName, childMirror) = JMOWrapperMirror[i]
                
                switch(childMirror.valueType) {
                case let x where x is String.Type:
                    return jsonString
                case let x where x is Optional<String>.Type:
                    return jsonString
                case let x where x is Int.Type:
                    return jsonString.toInt()
                case let x where x is Optional<Int>.Type:
                    return jsonString.toInt()
                case let x where x is Float.Type:
                    return (jsonString as NSString).floatValue
                case let x where x is Optional<Float>.Type:
                    return (jsonString as NSString).floatValue
                case let x where x is Double.Type:
                    return (jsonString as NSString).doubleValue
                case let x where x is Optional<Double>.Type:
                    return (jsonString as NSString).doubleValue
                case let x where x is NSDate.Type:
                    return jsonManagedObjectSharedInstance.dateFormatter.dateFromString(jsonString)
                case let x where x is Optional<NSDate>.Type:
                    return jsonManagedObjectSharedInstance.dateFormatter.dateFromString(jsonString)
                case let x where x is NSData.Type:
                    return (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                case let x where x is Optional<NSData>.Type:
                    return (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
                case let x where x is NSNumber.Type:
                    var numberFormatter = NSNumberFormatter()
                    return numberFormatter.numberFromString(jsonString)
                case let x where x is Optional<NSNumber>.Type:
                    var numberFormatter = NSNumberFormatter()
                    return numberFormatter.numberFromString(jsonString)
                case let x where x is NSInteger.Type:
                    return jsonString.toInt()
                case let x where x is Optional<NSInteger>.Type:
                    return jsonString.toInt()
                case let x where x is Bool.Type:
                    return (jsonString as NSString).boolValue
                case let x where x is Optional<Bool>.Type:
                    return (jsonString as NSString).boolValue
                case let x where x is Array<AnyObject>.Type:
                    return nil
                case let x where x is Optional<Array<AnyObject>>.Type:
                    return nil
                case let x where x is Dictionary<NSObject, AnyObject>.Type:
                    return nil
                case let x where x is Optional<Dictionary<NSObject, AnyObject>>.Type:
                    return nil
                case let x where x is Dictionary<String, AnyObject>.Type:
                    return nil
                case let x where x is Optional<Dictionary<String, AnyObject>>.Type:
                    return nil
                default:
                    var notFound = "NotFound"
                }
            }
        }
        return nil
    }
}
