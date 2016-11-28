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
        
        loadFoaas()
    }
    
    func loadFoaas(){
        self.mainTextLabel.text = ""
        self.subtitleTextLabel.text = ""
        FoaasAPIManager.getFoaas(url: URL(string: "http://www.foaas.com/madison/me/future")!) {
            (foaas: Foaas?) in
            if foaas != nil{
                DispatchQueue.main.async {
                    self.foaas = foaas
                    self.mainTextLabel.text = self.foaas?.message
                    self.subtitleTextLabel.text = "From,\n" + (self.foaas?.subtitle)!
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
