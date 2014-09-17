//
//  JMOConfigModel.swift
//  JsonManagedObject-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

public class JMOConfigModel {
    
    public var classInfo:JMOParameterModel
    public var parameters = [JMOParameterModel]()
    
    public init(classInfo:JMOParameterModel) {
        self.classInfo = classInfo
    }
    
    public subscript(index: Int) -> JMOParameterModel {
        get {
            return parameters[index]
        }
        set {
           parameters[index] = newValue
        }
    }
    
    // Parameter object
    public class JMOParameterModel {
        public let attribute:String
        public let objectType:String?
        public let jsonKey:String
        
        public init(attribute:String, jsonKey:String, objectType:String?) {
            self.attribute = attribute
            self.jsonKey = jsonKey
            self.objectType = objectType
        }
        
        public convenience init(attribute:String, jsonKey:String) {
            self.init(attribute: attribute, jsonKey: jsonKey, objectType: nil)
        }
    }
}

