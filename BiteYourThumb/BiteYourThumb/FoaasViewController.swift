//
//  FoaasViewController.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/26/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class FoaasViewController: UIViewController {
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    
    // The view controller in this case doesn't really need to keep a reference to the Foaas object, so we can re-write the code w/o it
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerForNotifications() // missed this one!
        loadFoaas()
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let notificationBundle = sender.userInfo {
            if let newFoaas = notificationBundle["foaas"] as? Foaas {
                self.updateLabel(with: newFoaas)
            }
        }
    }
    
    func loadFoaas(from url: URL = URL(string: "http://www.foaas.com/madison/me/future")!){
        self.mainTextLabel.text = ""
        self.subtitleTextLabel.text = ""
        
        // Excellent choice in using one of the longest URLs to test your label's bounds
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            if foaas != nil{
                self.updateLabel(with: foaas!)
            }
        }
    }
    
    func updateLabel(with foaas: Foaas){
        DispatchQueue.main.async {
            self.mainTextLabel.text = foaas.message
            self.subtitleTextLabel.text = "From,\n" + foaas.subtitle
        }
    }
    
}
