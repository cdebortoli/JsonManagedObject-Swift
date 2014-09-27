//
//  JMOConfigModel.swift
//  JsonManagedObject-Swift
//
//  Created by christophe on 08/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

// Represent a template of entity
public class JMOConfigModel {
    
    public var classInfo:JMOParameterModel // General detail of the entity
    public var parameters = [JMOParameterModel]() // Parameters of the entity
    
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
}

