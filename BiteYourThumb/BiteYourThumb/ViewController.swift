//
//  ViewController.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/22/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FoaasAPIManager.getOperations {
            (final: [FoaasOperation]?) in
            if final != nil{
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

