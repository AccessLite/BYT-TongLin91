//
//  FoaasOperation.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/22/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class FoaasOperation: JSONConvertible, DataConvertible{
    /*
     {
     "name": "Awesome",
     "url": "/awesome/:from",
     "fields": [
     {
     "name": "From",
     "field": "from"
     }
     ]
     },
     */
    let name: String
    let url: String
    let fields: [FoaasField]
    
    init(name: String, url: String, fields: [FoaasField]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let name: String = json["name"] as? String,
            let url: String = json["url"] as? String,
            let fields: [[String: AnyObject]] = json["fields"] as? [[String: AnyObject]] else { return nil }
        
        let allFields: [FoaasField] = fields.flatMap{ FoaasField(json: $0) }
        
        self.init(name: name, url: url, fields: allFields)
    }
    
    convenience required init?(data: Data) {
        do {
            let rawData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            
            if let validJson = rawData {
                self.init(json: validJson)
            } else {
                return nil
            }
            
        } catch {
            print("Error initialization parsing data in FoaasOperation: \(error)")
        }
        return nil
    }
    
    func toJson() -> [String : AnyObject] {
        return [
            "name": self.name as AnyObject,
            "url": self.url as AnyObject,
            "fields": self.fields.map{ $0.toJson() } as AnyObject]
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
}
