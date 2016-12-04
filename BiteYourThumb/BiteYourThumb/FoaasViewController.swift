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

    var foaas: Foaas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()
        loadFoaas()
    }
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let notificationBundle = sender.userInfo as? [String: Any]{
            if let newFoaas = notificationBundle["foaas"] as? Foaas {
                
                self.foaas = newFoaas
                self.updateView()
            }
        }
    }
    
    func loadFoaas(){
        self.mainTextLabel.text = ""
        self.subtitleTextLabel.text = ""
        FoaasAPIManager.getFoaas(url: URL(string: "http://www.foaas.com/madison/me/future")!) {
            (foaas: Foaas?) in
            if foaas != nil{
                DispatchQueue.main.async {
                    self.foaas = foaas
                    self.updateView()
                }
            }
        }
    }

    func updateView(){
        self.mainTextLabel.text = self.foaas?.message
        self.subtitleTextLabel.text = "From,\n" + (self.foaas?.subtitle)!
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

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
