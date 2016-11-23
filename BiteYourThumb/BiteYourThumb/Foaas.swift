//
//  Foaas.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/22/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class Foaas {
    let message: String
    let subtitle: String
    
    //Optional initialization for Foaas model
    init?(from dict:[String: Any]) {
        guard let message: String = dict["message"] as? String,
            let subtitle: String = dict["subtitle"] as? String else{
                return nil
        }
        self.message = message
        self.subtitle = subtitle
    }
    
    //Function parsing raw data and return Foaas
    static func getFoaas(data: Data) -> Foaas?{
        do {
            let json: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard let rawData: [String: Any] = json as? [String: Any] else { return nil }
            
            return Foaas(from: rawData)
            
        } catch {
            print("Error when parsing Foaas: \(error)")
        }
        return nil
    }

}
