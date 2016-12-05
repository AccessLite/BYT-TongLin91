//
//  FoaasDataManager.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/24/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class FoaasDataManager {
    static let shared: FoaasDataManager = FoaasDataManager()
    init() { }
    
    private static let operationsKey: String = "FoaasOperationsKey"
    private static let defaults = UserDefaults.standard
    internal private(set) var operations: [FoaasOperation]?
    
    func save(operations: [FoaasOperation]){
        //convert operations to data
        let data = operations.flatMap{ try? $0.toData() }
        FoaasDataManager.defaults.set(data, forKey: FoaasDataManager.operationsKey)
        FoaasDataManager.shared.operations = operations
        print("saving default data to key: " + FoaasDataManager.operationsKey)
    }
    
    func load() -> Bool{
        
        guard let validData = FoaasDataManager.defaults.value(forKey: FoaasDataManager.operationsKey) as? [Data] else{ return false }
        let operations = validData.flatMap{ FoaasOperation(data: $0) }
        
        FoaasDataManager.shared.operations = operations
        return true
    }
    
    func deleteStoredOperations(){
        FoaasDataManager.defaults.set(nil, forKey: FoaasDataManager.operationsKey)
        FoaasDataManager.shared.operations = nil
        print("delete default data for key: " + FoaasDataManager.operationsKey)
    }
    
    internal func requestOperations(_ operations: @escaping ([FoaasOperation]?)->Void) {
        FoaasAPIManager.getOperations(completion: operations)
    }
}
