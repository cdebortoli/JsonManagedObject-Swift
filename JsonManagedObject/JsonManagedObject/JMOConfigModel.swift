//
//  JMOConfigModel.swift
//  JsonManagedObject-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

class JMOConfigModel {
    
    var classInfo:JMOParameterModel
    var parameters = [JMOParameterModel]()
    
    init(classInfo:JMOParameterModel) {
        self.classInfo = classInfo
    }
    
    subscript(index: Int) -> JMOParameterModel {
        get {
            return parameters[index]
        }
        set {
           parameters[index] = newValue
        }
    }
    
    // Parameter object
    class JMOParameterModel {
        let attribute:String
        let objectType:String?
        let jsonKey:String
        
        init(attribute:String, jsonKey:String, objectType:String?) {
            self.attribute = attribute
            self.jsonKey = jsonKey
            self.objectType = objectType
        }
        
        convenience init(attribute:String, jsonKey:String) {
            self.init(attribute: attribute, jsonKey: jsonKey, objectType: nil)
        }
    }
}

