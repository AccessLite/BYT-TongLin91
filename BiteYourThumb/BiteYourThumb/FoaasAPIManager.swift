//
//  FoaasAPIManager.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/22/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class FoaasAPIManager {
    private static let defaultSession = URLSession(configuration: .default)
    
    internal class func getFoaas(url: URL, completion: @escaping (Foaas?)->Void){
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        defaultSession.dataTask(with: request){ (someData: Data?, _, someError: Error?) in
            if someError != nil{
                print("Error with foaas url request \(someError!)")
            }
            
            if someData != nil{
                do{
                    
                    let rawData = try JSONSerialization.jsonObject(with: someData!, options: []) as? [String: AnyObject]
                    
                    if let json = rawData{
                        completion(Foaas(json: json))
                    }
                    
                    return
                }catch{
                    print("Error serializing foaas data: \(error)")
                }
            }
        }.resume()
    }
    
    internal class func getOperations(completion: @escaping ([FoaasOperation]?)->Void ){
        var request: URLRequest = URLRequest(url: URL(string: "http://www.foaas.com/operations")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        defaultSession.dataTask(with: request) {(someData: Data?, _, someError: Error?) in
            if someError != nil{
                print("Error with foaas operation url request: \(someError!)")
            }
            
            if someData != nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: someData!, options: []) as? [[String: AnyObject]]
                    
                    var finalOperation = [FoaasOperation]()
                    
                    for element in json!{
                        finalOperation.append(FoaasOperation(json: element)!)
                    }
                    
                    completion(finalOperation)
                    
                }catch{
                    print("Error serializing operation data: \(error)")
                }
            }
        }.resume()
    }
    
}
