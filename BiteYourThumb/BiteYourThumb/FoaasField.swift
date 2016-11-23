//
//  FoaasField.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/22/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class FoaasField: JSONConvertible, CustomStringConvertible{
    /*
     {
     "name": "From",
     "field": "from"
     }
    */
    let name: String
    let field: String
    
    var description: String {
        return name + field
    }
    
    init(name: String, field: String) {
        self.name = name
        self.field = field
    }
    
    convenience required init?(json: [String : AnyObject]) {
        guard let name = json["name"] as? String,
            let field = json["field"] as? String else { return nil }
        self.init(name: name, field: field)
    }
    
    func toJson() -> [String : AnyObject] {
        return [
            "name": self.name as AnyObject,
            "field": self.field as AnyObject]
    }
    
}
