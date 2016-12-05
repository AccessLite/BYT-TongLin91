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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForNotifications()
        loadFoaas()
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let notificationBundle = sender.userInfo as? [String: Any]{
            if let newFoaas = notificationBundle["foaas"] as? Foaas {
                self.updateLabel(with: newFoaas)
            }
        }
    }
    
    func loadFoaas(from url: URL = URL(string: "http://www.foaas.com/madison/me/future")!){
        self.mainTextLabel.text = ""
        self.subtitleTextLabel.text = ""
        FoaasAPIManager.getFoaas(url: url) {
            (foaas: Foaas?) in
            if foaas != nil{
                DispatchQueue.main.async {
                    self.updateLabel(with: foaas!)
                }
            }
        }
    }
    
    // MARK: - Navigation

    @IBAction func octobuttonTapped(_ sender: UIButton) {
        // create references to the different transforms
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            // animate to newTransform
            sender.transform = newTransform
            
        }, completion: { (complete) in
            // return to original transform
            sender.transform = originalTransform
        })
    }

    func updateLabel(with foaas: Foaas){
        DispatchQueue.main.async {
            self.mainTextLabel.text = foaas.message
            self.subtitleTextLabel.text = "From,\n" + foaas.subtitle
        }
    }

}
