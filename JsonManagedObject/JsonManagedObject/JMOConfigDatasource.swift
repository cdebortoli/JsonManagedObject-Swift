//
//  JMOConfigDatasource.swift
//  JsonManagedObject
//
//  Created by christophe on 18/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

// Represent the configuration loaded from template file
internal class JMOConfigDatasource {
    internal var jmoObjects = [JMOConfigModel]()
    
    internal init() {
        jmoObjects = parseConfigObjectsFromConfigFile()
    }
    
    internal func parseConfigObjectsFromConfigFile() -> [JMOConfigModel] {
        var configObjects = [JMOConfigModel]()
        if let data = readConfigFile() {
            
            let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:nil) as [AnyObject]
            
            for configOccurenceOpt : AnyObject in jsonArray {
                if let configOccurence = configOccurenceOpt as? NSDictionary {
                    
                    // Class
                    var configClass = configOccurence["class"]! as NSDictionary
                    let configClassAttribute = configClass["attribute"]! as String
                    let configClassJsonKey = configClass["json"]! as String
                    
                    var newClassInfo = JMOParameterModel(attribute: configClassAttribute, jsonKey: configClassJsonKey)
                    var newJMOObject = JMOConfigModel(classInfo: newClassInfo)
                    
                    // Attributes
                    for configParameter in configOccurence["parameters"]! as [NSDictionary] {
                        let parameterAttribute = configParameter["attribute"]! as String
                        let parameterJsonKey = configParameter["json"]! as String
                        var parameterType = configParameter["type"] as? String
                        
                        var newConfigParameter = JMOParameterModel(attribute: parameterAttribute, jsonKey: parameterJsonKey, objectType: parameterType)
                        newJMOObject.parameters.append(newConfigParameter)
                    }
                    configObjects.append(newJMOObject)
                }
            }
        }
        
        return configObjects
    }
    
    internal func readConfigFile() -> NSData? {
        let configFilepath:String? = NSBundle.mainBundle().pathForResource("JMOConfigTemplate", ofType: "json")
        if let filepath = configFilepath {
            var errorFilepath:NSError?
            return NSData(contentsOfFile:filepath, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &errorFilepath)
        }
        return nil
    }
}

extension JMOConfigDatasource {
    internal subscript(attributeType: String) -> JMOConfigModel? {
        get {
            return getConfigForType(attributeType)
        }
    }
    
    internal func getConfigForType(attributeType:String) -> JMOConfigModel? {
        for jmoObject in jmoObjects {
            if jmoObject.classInfo.attributeName == attributeType {
                return jmoObject
            }
        }
        return nil
    }
}