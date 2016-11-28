//
//  FoaasPreviewViewController.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/27/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class FoaasPreviewViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var referenceTextField: UITextField!
    
    var operation: FoaasOperation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView(){
        self.navigationItem.title = self.operation?.name
        self.previewLabel.text = "You selected operation: " + (self.operation?.name)!
        
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
