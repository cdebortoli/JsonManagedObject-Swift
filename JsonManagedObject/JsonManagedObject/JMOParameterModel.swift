//
//  JMOParameterModel.swift
//  JsonManagedObject
//
//  Created by christophe on 27/09/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation

// Represent a parameter from JSON template

public class JMOParameterModel {
    public let attributeName:String // Object attribute name
    public let objectType:String?
    public let jsonKey:String
    
    public init(attribute:String, jsonKey:String, objectType:String?) {
        self.attributeName = attribute
        self.jsonKey = jsonKey
        self.objectType = objectType
    }
    
    public convenience init(attribute:String, jsonKey:String) {
        self.init(attribute: attribute, jsonKey: jsonKey, objectType: nil)
    }
}