//
//  FoaasDataManager.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/24/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

// Get in the habit of deleting your app from your sim and re-running it occasionally, and definitely at least once just before submitting
// You should always consider "first use" as a unique use-case and should always test your app like someone would if they had just downloaded it
internal class FoaasDataManager {
    static internal let shared: FoaasDataManager = FoaasDataManager()
    init() { }
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    static func save(operations: [FoaasOperation]){
        //convert operations to data
        let data = operations.flatMap{ try? $0.toData() }
        self.defaults.set(data, forKey: self.operationsKey)
      
        // not having this here will cause a crash on first run
        // this is because your tableview is force unwrapping the self.shared.operations.count value to get the count 
        // for its cells. but because on your first run you call save() without assigning your variable, we get a crash
        self.shared.operations = operations
        print("saving default data to key: " + self.operationsKey)
    }
    
    static func load() -> Bool{
        
        guard let validData = self.defaults.value(forKey: self.operationsKey) as? [Data] else{ return false }
        let operations = validData.flatMap{ FoaasOperation(data: $0) }
        
        self.shared.operations = operations
        return true
    }
    
    static func deleteStoredOperations(){
        self.defaults.set(nil, forKey: self.operationsKey)
        self.shared.operations = nil
        print("delete default data for key: " + self.operationsKey)
    }
}
