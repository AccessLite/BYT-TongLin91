//
//  FoaasDataManager.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/24/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

internal class FoaasDataManager {
    static internal let shared: FoaasDataManager = FoaasDataManager()
    init() { }
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    static func save(operations: [FoaasOperation]){
        self.defaults.set(operations, forKey: self.operationsKey)
        print("saving default data to key: " + self.operationsKey)
    }
    
    static func load() -> Bool{
        if let validData = self.defaults.value(forKey: self.operationsKey) as? [FoaasOperation]{
            //do something after we got data from UserDefaults
            self.shared.operations = validData
            return true
        }
        return false
    }
    
    static func deleteStoredOperations(){
        self.defaults.set(nil, forKey: self.operationsKey)
        print("delete default data for key: " + self.operationsKey)
    }
}
