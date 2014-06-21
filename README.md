EasyJson-Swift
==============
JSON to NSManagedObject and vice versa
-------------

##How to install it
1. Drag EasyJsonFramework in your project and add EasyJsonFramework as an embedded Framework.
2. Create and configure a, EasyJsonConfig.json file based on the EasyJsonConfig.json.tpl template file.
3. Import EasyJsonFramework in your code.

##How to configure it

###EasyJsonConfig file
The rool level of this file is an array which contain each object availables for the JSON Parsing.

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

     {
        "class" : { "attribute" : "NSObjectClassName", "json": "JSONKey" },
        "parameters" : [
                    { "attribute": "NSObjectAttributeName", "json": "JSONKey" },
                    { "attribute": "NSObjectAttributeName", "json": "JSONKey" },
                    { "attribute": "NSObjectAttributeArrayName", "json": "JSONKey", "type": "ObjectTypeInArray" },
                    { "attribute": "NSObjectAttributeDictionaryName", "json": "JSONKey", "type": "ObjectTypeInDictionary" }
                   ]
    }
For NSArray and NSDictionary attributes, you need to specify the type of objects contained in these attributes.

**Warning: The NSObject parsing is currently not available. Swift limitation : https://devforums.apple.com/message/985320#985320**


###Configuration parameters
To configure your EasyJsonFramework, call the struct EasyJsonConfig. With it, you can configure 3 parameters.

**Envelope Format**
Set to true if your JSON data is specified by a key value.

    EasyJsonConfig.jsonWithEnvelope = true

Example for an Aircraft object with json envelope:

    { "Aircraft": { "AircraftId": 1, "AircraftName": "Airbus" } }

And without the envelope:

    { "AircraftId": 1, "AircraftName": "Airbus" }

**Date Format**

Set the date format used to analyze your json.

    EasyJsonConfig.dateFormat = "yyyy-MM-dd"

**Managed Object Context**

Set your managedObjectContext to allow EasyJson to init an NSManagedObject.

    EasyJsonConfig.managedObjectContext = yourManagedObjectContext

**Temporary managed object**

If you don't want to store the parsed objects in your ManagedObjectContext, you need to set the temporaryNSManagedObjectInstance parameter to true.

    EasyJsonConfig.temporaryNSManagedObjectInstance = true


##How to use it

Your can access to EasyJson with the Singleton "easyJsonSharedInstance".

To bind a JSON Object to a NSManagedObject:

    var a1:Aircraft? = easyJsonSharedInstance.analyzeJsonDictionary(dict, forClass:Aircraft.classForCoder()) as? Aircraft

To bind a array of JSON Objects to NSManagedObjects:

    var aircrafts = easyJsonSharedInstance.analyzeJsonArray(aircraftArray, forClass: Aircraft.classForCoder()) as Aircraft[]

To convert a NSmanagedObject in a Dictionary which is ready for JSON Serialization, call the NSManagedObject method named "getEasyJson".
   
     func getEasyJson(relationshipClassesToIgnore:String[] = String[]()) -> Dictionary <String, AnyObject>{

In parameter of this method, you can pass the string representations of Class which will be ignored during the parsing.
The EasyJson Framework use this array parameter with the recursive call to avoid infinite loops.


##How to test it
EasyJsonFramework has a test helper to analyze your JSON Mocks.
To use the tests:

1. Import EasyJsonFramework in your tests files/bundle.
2. Create the mocks of your JSON Services with files which follows this name pattern : "EasyJsonMock[CustomTitle].json". Replace [CustomTitle] by the title of your choice.
3. Call the "checkMocksFromBundle" of "EasyJsonTestHelper".

The checkMocksFromBundle method except as second parameter a closure. For each property defined in your EasyJsonConfig file, a call to your closure will be made.

This closure has as parameter a tuple which contain the propertyValue extracted from the JSON, and the corresponding property name.

Exemple of use :

    EasyJsonTestHelper.checkMocksFromBundle(NSBundle(forClass: self.dynamicType), {(completion:(attributeValue: AnyObject?, attributeName: String)) -> () in
            if completion.attributeValue is NSSet {
                XCTAssert((completion.attributeValue as NSSet).count > 0, "Check relation : \(completion.attributeName)")
            } else {
                XCTAssertNotNil(completion.attributeValue, "Check attributeKey : \(completion.attributeName)")
            }
        })

