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
        let dict = dictionaryFromService("aircraftJsonWithEnvelope")
        var aircraft:Aircraft? = jsonManagedObjectSharedInstance.analyzeJsonDictionary(dict, forClass:Aircraft.classForCoder()) as? Aircraft
        println(aircraft)
        
        // ------------------ Get multiple Aircrafts from JSON ------------------
        let aircraftArray = arrayFromJson("aircraftsJsonWithEnvelope")
        var aircrafts = jsonManagedObjectSharedInstance.analyzeJsonArray(aircraftArray, forClass: Aircraft.classForCoder()) as Aircraft[]
        println(aircrafts)
        
        // ------------------ Get JSON from Aircraft ------------------
        let aircraftJsonRepresentation = aircraft?.getJmoJson()
        println(aircraftJsonRepresentation)
        
        // ------------------ Get Custom object from JSON ------------------
        //        let customObjectDict = dictionaryFromService("customObjectJson")
        //        var customObject:CustomObject? = jsonManagedObjectSharedInstance.analyzeJsonDictionary(customObjectDict, forClass: CustomObject.self) as? CustomObject
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dictionaryFromService(service:String) -> Dictionary<String,AnyObject> {
        let filepath = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, AnyObject>
        return json
    }
    
    func arrayFromJson(service:String) -> AnyObject[] {
        let filepath = NSBundle.mainBundle().pathForResource(service, ofType: "json")
        let filecontent = NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        let json = NSJSONSerialization.JSONObjectWithData(filecontent, options: NSJSONReadingOptions.MutableContainers, error: nil) as AnyObject[]
        return json
    }


}

