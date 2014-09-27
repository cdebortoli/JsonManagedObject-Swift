//
//  CustomObject.swift
//  JMODemo
//
//  Created by christophe on 20/09/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import UIKit
import JsonManagedObject

@objc(CustomObject) public class CustomObject: JMOWrapper {
    public var attrString:String?
    public var attrDate:NSDate?
    public var attrData:NSData?
    public var attrNumber:NSNumber?
//    public var attrInt:Int?
//    public var attrInteger:NSInteger?
//    public var attrFloat:Float?
//    public var attrDouble:Double?
//    public var attrBool:Bool?
//    public var attrArray:[AnyObject]?
//    public var attrDictionary:[NSObject: AnyObject]?
}