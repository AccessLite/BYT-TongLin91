//
//  FoaasViewController.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/26/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class FoaasViewController: UIViewController{
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForNotifications()
        loadFoaas()
    }
    
    @IBAction func didPerformGesture(_ sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began {
            switch sender {
            case longPressGesture:
                UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, UIScreen.main.scale )
                view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                //Save it to the camera roll
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.createScreenShotCompletion(image:didFinishSavingWithError:contextInfo:)), nil)
                
            case tapGesture:
                let activityViewController = UIActivityViewController(
                    activityItems: [self.mainTextLabel.text!, self.subtitleTextLabel.text!],
                    applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
                
            default:
                print("Unknow gesture triggered.")
            }
        }
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
    
    func loadFoaas(){
        self.mainTextLabel.text = "Loading..."
        self.subtitleTextLabel.text = ""
        FoaasDataManager.shared.requestFoaas(endpoint: "http://www.foaas.com/everything/Anonymous") {
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

    internal func updateLabel(with foaas: Foaas){
        DispatchQueue.main.async {
            self.mainTextLabel.text = foaas.message
            self.subtitleTextLabel.text = "From,\n" + foaas.subtitle
        }
    }
    
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        // check if error != nil
        if let error = didFinishSavingWithError{
            print("error saving photo: \(error)")
            // present appropriate message in UIAlertViewController
            let alert = UIAlertController(title: "Error", message: "Screenshot Error!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Complete", message: "Screenshot Saved to Library.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            // double check that the image actually gets saved to the camera roll
         
        }
        
    }

}
