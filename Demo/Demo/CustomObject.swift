//
//  CustomObject.swift
//  EasyJson-Swift
//
//  Created by christophe on 09/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import Foundation
import JsonManagedObject

@objc(CustomObject) class CustomObject : JMOWrapper {

    var attrString:String?
    var attrDate:NSDate?
    var attrData:NSData?
    var attrNumber:NSNumber?
    var attrInteger:NSInteger?
    var attrInt:Int?
    var attrFloat:Float?
    var attrDouble:Double?
    var attrBool:Bool?
    var attrArray:AnyObject[]?
    var attrDictionary:Dictionary<NSObject, AnyObject>?
    
}