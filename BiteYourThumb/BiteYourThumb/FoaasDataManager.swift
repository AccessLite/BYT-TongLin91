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
        //convert operations to data
        
        let data = operations.flatMap{ try? $0.toData() }
        
        self.defaults.set(data, forKey: self.operationsKey)
        print("saving default data to key: " + self.operationsKey)
        
    }
    
    static func load() -> Bool{
        guard let validData = self.defaults.value(forKey: self.operationsKey) as? [Data] else{
            return false
        }
        
        var finalVariable = [FoaasOperation]()
        validData.forEach{
            (element: Data) in
            finalVariable.append(FoaasOperation(data: element)!)
        }
        
        // this isn't needed since operations will get overriden anyhow by re-assigning its value to finalVariable
//        self.shared.operations?.removeAll()
        self.shared.operations = finalVariable
        
        return true
    }
    
    static func deleteStoredOperations(){
        self.defaults.set(nil, forKey: self.operationsKey)
        print("delete default data for key: " + self.operationsKey)
    }
}
