//
//  ViewController.swift
//  JMODemo
//
//  Created by christophe on 21/06/14.
//  Copyright (c) 2014 cdebortoli. All rights reserved.
//

import UIKit
import JsonManagedObject

class ViewController: UIViewController {
                            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ------------------ Configuration ------------------
        JMOConfig.jsonWithEnvelope = true
        JMOConfig.dateFormat = "yyyy-MM-dd"
        JMOConfig.managedObjectContext = databaseManagerSharedInstance.databaseCore.managedObjectContext
        JMOConfig.temporaryNSManagedObjectInstance = true
        
        // ------------------ Get Aircraft from JSON ------------------
        let dictOptional = dictionaryFromService("aircraftJsonWithEnvelope")
        if let dict = dictOptional {
            var aircraft:Aircraft? = jsonManagedObjectSharedInstance.analyzeJsonDictionary(dict, forClass:Aircraft.classForCoder()) as? Aircraft
            println(aircraft)
            
            // ------------------ Get JSON from Aircraft ------------------
            let aircraftJsonRepresentation = aircraft?.getJson()
            println(aircraftJsonRepresentation)
        }
        
        // ------------------ Get multiple Aircrafts from JSON ------------------
        let aircraftArrayOptional = arrayFromJson("aircraftsJsonWithEnvelope")
        if let aircraftArray = aircraftArrayOptional {
            var aircrafts = jsonManagedObjectSharedInstance.analyzeJsonArray(aircraftArray, forClass: Aircraft.classForCoder()) as [Aircraft]
            println(aircrafts)
        }
        
        // ------------------ Get Custom object from JSON ------------------
        let customObjectDictOptional = dictionaryFromService("customObjectJson")
        if let customObjectDict = customObjectDictOptional {
            var customObject:CustomObject? = jsonManagedObjectSharedInstance.analyzeJsonDictionary(customObjectDict, forClass: CustomObject.self) as? CustomObject
            println(customObject!.attrString)
            println(customObject!.attrNumber)
            println(customObject!.attrDate)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dictionaryFromService(service:String) -> [String: AnyObject]? {
        let filepathOptional = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        if let filepath = filepathOptional {
            let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
            let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as [String: AnyObject]
            return json
        }
        return nil
    }
    
    func arrayFromJson(service:String) -> [AnyObject]? {
        let filepathOptional = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        if let filepath = filepathOptional {
            let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
            let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as [AnyObject]
            return json
        }
        return nil
    }


}

