//
//  Foaas.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/22/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class Foaas: JSONConvertible, CustomStringConvertible {
    /*
     {
     "message": "This is Fucking Awesome.",
     "subtitle": "- Tong"
     }
    */
    let message: String
    let subtitle: String
    var description: String {
        return message + subtitle
    }
    
    init(message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }

    convenience required init?(json: [String : AnyObject]) {
        guard let message: String = json["message"] as? String,
            let subtitle: String = json["subtitle"] as? String else{ return nil }
        self.init(message: message, subtitle: subtitle)
    }
    
    func toJson() -> [String : AnyObject] {
        return [
        "message": self.message as AnyObject,
        "subtitle": self.subtitle as AnyObject
        ]
    }
}
