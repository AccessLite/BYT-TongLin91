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
        
        var allFields: [FoaasField] = []
        
        for element in fields{
            if let foaas = FoaasField(json: element){
                allFields.append(foaas)
            }
        }
        self.init(name: name, url: url, fields: allFields)
    }
    
    convenience required init?(data: Data) {
        do {
            let rawData: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard let json: [String: AnyObject] = rawData as? [String: AnyObject] else { return nil }
            
            self.init(json: json)
        } catch {
            print("Error initialization parsing data in FoaasOperation: \(error)")
        }
        return nil
    }
    
    func toJson() -> [String : AnyObject] {
        return [
            "name": self.name as AnyObject,
            "url": self.url as AnyObject,
            // I don't have a really good reason as to why this *must* be map. But it must be map.
            // I have a basis for a theory: from exploring this using breakpoints, there's some internal heap that's
            // used in these flatMap operations that allows for an Optional to be added. And *somehow*, that
            // optional sticks around to get read in by JSONSerialization. But since type Optional is not valid
            // to be serialized, we get an error. But I have no other clues in their theory, so I welcome your help.
            "fields": self.fields.map{ $0.toJson() } as AnyObject]
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
    }
}
