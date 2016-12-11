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
    
    init(operation: FoaasOperation) {
        var finalFields: [String: String] = [:]
        for field in operation.fields{
            finalFields[field.field] = "field"
        }
        
        self.operation = operation
        self.operationFields = finalFields
    }
    
    func build() -> String {
        guard self.operationFields.count > 0 else{ return self.operation.url }
        var newURL = self.operation.url
        for (key, value) in self.operationFields{
            newURL = newURL.replacingOccurrences(of: ":\(key)", with: value, options: .literal, range: nil)
        }
        return newURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func update(key: String, value: String)  {
        if self.operationFields[key] != nil{
            self.operationFields[key] = value
            print("\(key) updated")
        }
    }
    
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
    
    func allKeys() -> [String] {
        return self.operation.fields.map { $0.field }
    }
}
