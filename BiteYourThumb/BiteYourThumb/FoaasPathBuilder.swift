//
//  FoaasPathBuilder.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 12/5/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class FoaasPathBuilder {
    var operation: FoaasOperation!
    var operationFields: [String : String]!
    
    /**
     Flattens an array of [FoaasField] with identical keys, into a one-dimensional array of [String:String] while performing
     a case-insensitive comparison of key-value pairs to store only unique keys.
     
     - parameter operation: The `FoaasOperation` to use in building a URL path.
     */
    init(operation: FoaasOperation) {
        for field in operation.fields{
            self.operationFields[field.field] = "field"
        }
        self.operation = operation
    }
    
    /**
     Goes through a `FoaasOperation.url` to replace placeholder text with its corresponding value stored in self.operationsField
     in the correct order. The String is also passed back with percent encoding automatically applied.
     
     example:
     self.operationFields = [ "from" : "Grumpy Cat", "name" : "Nala Cat"]
     self.operation.url = "/bus/:name/:from/"
     
     build() // returns "/bus/Nala%20Cat/Grumpy%20Cat"
     
     - returns: A `String` that corresponds to the path component needed to create a `URL` to request a `Foaas` object
     */
    func build() -> String {
        guard self.operationFields.count > 0 else{ return self.operation.url }
        var newURL = self.operation.url
        for (key, value) in self.operationFields{
            newURL = newURL.replacingOccurrences(of: ":\(key)", with: value, options: .literal, range: nil)
        }
        return newURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    /**
     Updates the `value` of an element with the corresponding `key`. If the `key` does not exist, nothing happens.
     
     - parameter key: The key of an element in `self.operationFields`
     - parameter value: The value to change to.
     */
    func update(key: String, value: String)  {
        if self.operationFields[key] != nil{
            self.operationFields[key] = value
            print("\(key) updated")
        }
    }
    
    /**
     Utility function to get the index of a specified key in its correct order in the `FoaasOperation.url` property.
     
     For example, for the Ballmer operation, its corresponding FoaasOperation.url is `/ballmer/:name/:company/:from`
     
     - indexOf(key: "name") // should return 0
     - indexOf(key: "company") // should return 1
     - indexOf(key: "from") // should return 2
     - indexOf(key: ":name") // should return nil
     - indexOf(key: "tool") // should return nil
     
     - parameter key: The key in self.operationFields to search for.
     - returns: The index position of the key if it exists in self.operationFields. `nil` otherwise.
     - seealso: `FoaasPathBuilder.allKeys`
     */
    func indexOf(key: String) -> Int? {
        if self.operationFields[key] != nil{
            for index in 0..<self.operation.fields.count{
                if self.operation.fields[index].field == key{
                    return index
                }
            }
        }
        return nil
    }
    
    /**
     Utility method that returns all of the keys for a `FoaasOperation`'s `field`s
     
     - returns: The keys contained in `self.operation.fields` as `[String]`
     */
    func allKeys() -> [String] {
        return self.operation.fields.map { $0.field }
    }
}
