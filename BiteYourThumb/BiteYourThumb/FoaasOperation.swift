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
    let fields: [FoaasField?]
    
    init(name: String, url: String, fields: [FoaasField?]) {
        self.name = name
        self.url = url
        self.fields = fields
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let name: String = json["name"] as? String,
            let url: String = json["url"] as? String,
            let fields: [[String: AnyObject]] = json["fields"] as? [[String: AnyObject]] else { return nil }
        
        var allFields: [FoaasField?] = []
        
        for element in fields{
            if let foaas = FoaasField(json: element){
                allFields.append(foaas)
            }
        }
        self.init(name: name, url: url, fields: allFields)
    }
    
    convenience required init?(data: Data) {
        do {
            let rawData: [String: AnyObject] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            self.init(json: rawData)
        } catch {
            print("Error initialization parsing data in FoaasOperation: \(error)")
        }
        return nil
    }
    
    func toJson() -> [String : AnyObject] {
        return [
            "name": self.name as AnyObject,
            "url": self.url as AnyObject,
            "fields": (self.fields.isEmpty ? [] : self.fields.map{ $0!.toJson() }) as AnyObject]
    }
    
    func toData() throws -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self.toJson())
    }
}
