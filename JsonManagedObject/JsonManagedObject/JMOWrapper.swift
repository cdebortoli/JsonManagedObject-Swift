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
        if let parameter = jmoParameter as? JMOParameterModel {
            
            if jsonDict[parameter.jsonKey] != nil {
                setValue(parameter, fromJson: jsonDict)
            }
        }
    }
    
    //    Error: Can't set value for optional primitive type with swift.
    internal func setValue(jmoParameter:JMOParameterModel, fromJson jsonDict:[String: AnyObject]) {
        
        if let jsonDictValue: AnyObject = jsonDict[jmoParameter.jsonKey] {
            if jsonDictValue is String {
                setStringValue(jmoParameter, fromJsonStringValue: (jsonDictValue as String))
            } else if jsonDictValue is NSNumber {
                setStringValue(jmoParameter, fromJsonStringValue: "\(jsonDictValue as NSNumber)")
            } else if jsonDictValue is [[String:AnyObject]] {
                setArrayValue(jmoParameter, fromJsonArrayValue: (jsonDictValue as [[String:AnyObject]]))
            } else if jsonDictValue is [String: AnyObject] {
                setDictionaryValue(jmoParameter, fromJsonDictValue: (jsonDictValue as [String: AnyObject]))
            }
        }
    }
        
    // Set the value of attribute with a string from the json
    internal func setStringValue(jmoParameter:JMOParameterModel, fromJsonStringValue jsonStringValue:String?) {
        if let jsonString = jsonStringValue {
            let JMOWrapperMirror = reflect(self)
            for var i = 0; i < JMOWrapperMirror.count; i++ {
                let (propertyName, childMirror) = JMOWrapperMirror[i]
                
                if propertyName == jmoParameter.attributeName {
                    switch(childMirror.valueType) {
                    case let x where x is String.Type:
                        setValue(jsonString, forKey: propertyName)
                    case let x where x is Optional<String>.Type:
                        setValue(jsonString, forKey: propertyName)
                    case let x where x is Int.Type:
                        var numberFormatter = NSNumberFormatter()
                        setValue(numberFormatter.numberFromString(jsonString), forKey: propertyName)
                    case let x where x is Optional<Int>.Type:
                        var numberFormatter = NSNumberFormatter()
                        setValue(numberFormatter.numberFromString(jsonString), forKey: propertyName)
                    case let x where x is Float.Type:
                        setValue((jsonString as NSString).floatValue, forKey: propertyName)
                    case let x where x is Optional<Float>.Type:
                        setValue((jsonString as NSString).floatValue, forKey: propertyName)
                    case let x where x is Double.Type:
                        setValue((jsonString as NSString).doubleValue, forKey: propertyName)
                    case let x where x is Optional<Double>.Type:
                        setValue((jsonString as NSString).doubleValue, forKey: propertyName)
                    case let x where x is NSDate.Type:
                        setValue(jsonManagedObjectSharedInstance.dateFormatter.dateFromString(jsonString), forKey: propertyName)
                    case let x where x is Optional<NSDate>.Type:
                        setValue(jsonManagedObjectSharedInstance.dateFormatter.dateFromString(jsonString), forKey: propertyName)
                    case let x where x is NSData.Type:
                        setValue((jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding), forKey: propertyName)
                    case let x where x is Optional<NSData>.Type:
                        setValue((jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding), forKey: propertyName)
                    case let x where x is NSNumber.Type:
                        var numberFormatter = NSNumberFormatter()
                        setValue(numberFormatter.numberFromString(jsonString), forKey: propertyName)
                    case let x where x is Optional<NSNumber>.Type:
                        var numberFormatter = NSNumberFormatter()
                        setValue(numberFormatter.numberFromString(jsonString), forKey: propertyName)
                    case let x where x is NSInteger.Type:
                        setValue(jsonString.toInt(), forKey: propertyName)
                    case let x where x is Optional<NSInteger>.Type:
                        setValue(jsonString.toInt(), forKey: propertyName)
                    case let x where x is Bool.Type:
                        setValue((jsonString as NSString).boolValue, forKey: propertyName)
                    case let x where x is Optional<Bool>.Type:
                        setValue((jsonString as NSString).boolValue, forKey: propertyName)
                    default:
                        println("NA")
                    }
                }
            }
        }
    }
    
    // Set the value of attribute with an array from the json
    internal func setArrayValue(jmoParameter:JMOParameterModel, fromJsonArrayValue jsonArrayValueOptional:[[String:AnyObject]]?) {
        
        if let jsonArrayValue = jsonArrayValueOptional {
            
            var parsedObjects = jsonManagedObjectSharedInstance.analyzeJsonArray(jsonArrayValue, forClass: NSClassFromString(jmoParameter.objectType))
            setValue(parsedObjects, forKey: jmoParameter.attributeName)
            
        }
    }
    
    // Set the value of attribute with a dictionary from json
    internal func setDictionaryValue(jmoParameter:JMOParameterModel, fromJsonDictValue jsonDictValueOptional:[String:AnyObject]?) {
        if let jsonDictValue = jsonDictValueOptional {
            var parsedDictionary = [String: AnyObject]()
            for jsonDictKey:String in [String](jsonDictValue.keys) {
                var parsedObject: AnyObject? = jsonManagedObjectSharedInstance.analyzeJsonDictionary((jsonDictValue[jsonDictKey]! as [String: AnyObject]),forClass: NSClassFromString(jmoParameter.objectType))
                parsedDictionary[jsonDictKey] = parsedObject
            }
            setValue(parsedDictionary, forKey: jmoParameter.attributeName)
        }
    }
    
}
