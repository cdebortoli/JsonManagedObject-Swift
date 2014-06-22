JsonManagedObject-Swift
==============
###JSON to NSManagedObject and vice versa


##Installation
1. Drag the JsonManagedObject project in your project and add JsonManagedObject as an embedded Framework.
2. Create and configure a JMOConfigTemplate.json file based on the JMOConfigTemplate.tpl template file.
3. Import JsonManagedObject in your code.

##Configuration

###JMOConfigTemplate file
The root level of this file is an array which contain each object availables for the JSON Parsing.

Two kinds of object can be specified in this file:

**NSManagedObject**

     {
        "class" : { "attribute"  : "ManagedObjectClassName", "json" : "JSONKey" },
        "parameters" : [
                     { "attribute": "ManagedObjectAttributeName", "json": "JSONKey" },
                     { "attribute": "ManagedObjectAttributeName", "json": "JSONKey" }
                    ]
    }

**NSObject**
**The NSObject parsing is currently not available. Swift limitation : https://devforums.apple.com/message/985320#985320**


###Configuration parameters
To configure the parameters of the JsonManagedObject framework, you need to use the JMOConfig struct. With it, you can configure the 4 following parameters.


**Envelope Format**

Set to true if your JSON data are specified under a key value.

    JMOConfig.jsonWithEnvelope = true

Example for an Aircraft object with json envelope:

    { "Aircraft": { "AircraftId": 1, "AircraftName": "Airbus" } }

And without the envelope:

    { "AircraftId": 1, "AircraftName": "Airbus" }


**Date Format**

Set the date format used to analyze your json.

    JMOConfig.dateFormat = "yyyy-MM-dd"


**Managed Object Context**

Set the managedObjectContext parameter to allow JsonManagedObject to instantiate an NSManagedObject.

    JMOConfig.managedObjectContext = yourManagedObjectContext


**Temporary managed object**

If you don't want to store the parsed objects in your ManagedObjectContext, you need to set the temporaryNSManagedObjectInstance parameter to true.

    JMOConfig.temporaryNSManagedObjectInstance = true


##How to use it

You can access to JsonManagedObject with the Singleton "jsonManagedObjectSharedInstance".

To bind a JSON Object to a NSManagedObject:

    var a1:Aircraft? = jsonManagedObjectSharedInstance.analyzeJsonDictionary(dict, forClass:Aircraft.classForCoder()) as? Aircraft

To bind a array of JSON Objects to NSManagedObjects:

    var aircrafts = jsonManagedObjectSharedInstance.analyzeJsonArray(aircraftArray, forClass: Aircraft.classForCoder()) as Aircraft[]

To convert a NSmanagedObject in a Dictionary which is ready for JSON Serialization, call the NSManagedObject method named "getJmoJson".
   
     func getJmoJson(relationshipClassesToIgnore:String[] = String[]()) -> Dictionary <String, AnyObject>{

The parameter of this method contains the string representations of Class which will be ignored during the parsing.
The JsonManagedObject Framework uses this array with the recursive call to avoid infinite loops.


##Unit tests with your mocks
JsonManagedObject has a test helper to analyze your JSON Mocks.
To test your mocks:

1. Import the JsonManagedObject Framework in your tests files/bundle.
2. Create the mocks of your JSON Services with files which follows this name pattern : "JMOMock[CustomTitle].json". Replace [CustomTitle] by the title of your choice.
3. Call the "checkMocksFromBundle" method of the "JMOTestHelper" class.

The checkMocksFromBundle method requires, as second parameter, a closure. For each property defined in your JMOConfig file, a call to your closure will be made.

This closure has as parameter a tuple which contain the propertyValue extracted from the JSON, and the corresponding property name.

Exemple of use :

    JMOTestHelper.checkMocksFromBundle(NSBundle(forClass: self.dynamicType), {(completion:(attributeValue: AnyObject?, attributeName: String)) -> () in
            if completion.attributeValue is NSSet {
                XCTAssert((completion.attributeValue as NSSet).count > 0, "Check relation : \(completion.attributeName)")
            } else {
                XCTAssertNotNil(completion.attributeValue, "Check attributeKey : \(completion.attributeName)")
            }
        })
**Warning: A xcode bug creates an error at the fifth call of XCTAssertNotNil with a nil object**

