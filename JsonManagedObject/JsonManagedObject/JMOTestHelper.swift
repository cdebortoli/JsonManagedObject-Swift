//
//  JMOTestHelper.swift
//  JsonManagedObject
//
//  Created by christophe on 14/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import CoreData

public class JMOTestHelper {
    
    // For the specified managed objects, completion closure called for each parameter
    // Tuple = Value parsed (if exist) and attribute name
    public class func checkMocksFromBundle(bundle:NSBundle, completion: ((attributeValue:AnyObject?, attributeName:String)) -> ())
    {
        for object:AnyObject in getObjectParsed(bundle) {
            
            // NSManagedObject
            if object.superclass is NSManagedObject.Type {
        
                if let configObject = jsonManagedObjectSharedInstance.configDatasource[NSStringFromClass(object.classForCoder)] {
                    
                    for parameter in configObject.parameters {
                        if let objectProperty = (object as NSManagedObject).getPropertyDescription(parameter) {
                            // Completion tuple/closure
                            var completionTuple:(attributeValue:AnyObject?, attributeName:String)
                            completionTuple.attributeValue = nil
                            if let valueObject:AnyObject = (object as? NSManagedObject)?.valueForKey(parameter.attribute) {
                                completionTuple.attributeValue = valueObject
                            }
                            completionTuple.attributeName = parameter.attribute
                            completion(completionTuple)
                        }
                    }
                    
                }
            // JMOWrapper
            } else if object.superclass is JMOWrapper.Type {
                //                TODO When SWIFT will manage get property of optionals
            }
        }
    }
    
    // Return an array of NSManagedObject and JMOWrapper object with data loaded from json mocks
    public class func getObjectParsed(bundle:NSBundle) -> [AnyObject] {
        var objectsParsed = [AnyObject]()
        for mockFilepath in self.getMockJson(bundle) {
            
            // Mock Data
            var errorData:NSError?
            let mockData = NSData.dataWithContentsOfFile(mockFilepath, options: nil, error: &errorData)
            
            if errorData == nil {
                // Mock Json
                var errorJson:NSError?
                let jsonDictionary = NSJSONSerialization.JSONObjectWithData(mockData, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as [String: AnyObject]
                
                if errorJson == nil {
                    let mockJson:AnyObject = jsonDictionary["mock"]!
                    let mockClassStrOptional = jsonDictionary["class"]! as? String
                    let mockClass:AnyClass = NSClassFromString(mockClassStrOptional!)

                    // Dictionary
                    if (mockJson is [String: AnyObject]) {
                        var objectOptional:AnyObject? = jsonManagedObjectSharedInstance.analyzeJsonDictionary(mockJson as [String: AnyObject], forClass:mockClass)
                        if let object : AnyObject = objectOptional {
                            objectsParsed.append(object)
                        }
                    // Array
                    } else if (mockJson is [AnyObject]) {
                        var objects = jsonManagedObjectSharedInstance.analyzeJsonArray(mockJson as [AnyObject], forClass: mockClass)
                        objectsParsed.append(objects)
                    }
                }
                
            }
        }
        return objectsParsed
    }
    
    // Search the mock files in the specified bundle
    private class func getMockJson(bundle:NSBundle) -> [String] {
        var filepaths = [String]()
        let fileEnumeratorOptional = NSFileManager.defaultManager().enumeratorAtPath(bundle.bundlePath)
        if let fileEnumerator = fileEnumeratorOptional {
            while let filepath = fileEnumerator.nextObject() as? String {
                if (filepath.pathExtension == "json") && (countElements(filepath) > 7) && (filepath.substringToIndex(advance(filepath.startIndex, 7)) == "JMOMock") {
                    filepaths.append("\(bundle.bundlePath)/\(filepath)")
                }
            }
        }
        return filepaths
    }
    
}
