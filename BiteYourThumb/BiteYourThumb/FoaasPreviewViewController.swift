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
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!

    var firstKeyWord: String = ""
    var secondKeyWord: String = ""
    var thirdKeyWord: String = ""
    var operation: FoaasOperation?
    var foaas : Foaas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.operation?.name
        self.previewLabel.text = self.operation?.name

        setupView()
        updatePreview()
      
        self.firstTextField.delegate = self
        self.secondTextField.delegate = self
        self.thirdTextField.delegate = self
    }
    
    func setupView(){
        switch (self.operation?.fields.count)! {
        case 1:
            print("need 1 text field")
            self.firstLabel.text = self.operation?.fields[0].name
            self.firstTextField.placeholder = self.operation?.fields[0].name
            self.secondLabel.isHidden = true
            self.secondTextField.isHidden = true
            self.thirdLabel.isHidden = true
            self.thirdTextField.isHidden = true
            self.firstKeyWord = (self.operation?.fields[0].field)!
        case 2:
            print("need 2 text fields")
            self.firstLabel.text = self.operation?.fields[0].name
            self.firstTextField.placeholder = self.operation?.fields[0].name
            self.secondLabel.text = self.operation?.fields[1].name
            self.secondTextField.placeholder = self.operation?.fields[1].name
            self.thirdLabel.isHidden = true
            self.thirdTextField.isHidden = true
            self.firstKeyWord = (self.operation?.fields[0].field)!
            self.secondKeyWord = (self.operation?.fields[1].field)!
        case 3:
            print("need 3 text fields")
            self.firstLabel.text = self.operation?.fields[0].name
            self.firstTextField.placeholder = self.operation?.fields[0].name
            self.secondLabel.text = self.operation?.fields[1].name
            self.secondTextField.placeholder = self.operation?.fields[1].name
            self.thirdLabel.text = self.operation?.fields[2].name
            self.thirdTextField.placeholder = self.operation?.fields[2].name
            self.firstKeyWord = (self.operation?.fields[0].field)!
            self.secondKeyWord = (self.operation?.fields[1].field)!
            self.thirdKeyWord = (self.operation?.fields[2].field)!
        default:
            print("dismiss all text fields")
            self.firstLabel.isHidden = true
            self.firstTextField.isHidden = true
            self.secondLabel.isHidden = true
            self.secondTextField.isHidden = true
            self.thirdLabel.isHidden = true
            self.thirdTextField.isHidden = true
        }
    }

    func updatePreview(){
        FoaasAPIManager.getFoaas(url: URL(string: self.getEndpoint())!){ (foaas: Foaas?) in
            if foaas != nil{
                DispatchQueue.main.async {
                    self.previewLabel.text = (foaas?.message)! + (foaas?.subtitle)!
                    self.foaas = foaas
                }
            }
        }
    }
    
    internal func getEndpoint() -> String{
        // your code crashes if URL has a space in it because you're not sending back percent encoded strings
        let header = (self.operation?.url.components(separatedBy: "/:").first)!
        var returnString: String
        switch (self.operation?.fields.count)! {
        case 1:
            returnString = "http://www.foaas.com\(header)/\(firstKeyWord)"
        case 2:
            returnString = "http://www.foaas.com\(header)/\(firstKeyWord)/\(secondKeyWord)"
        case 3:
            returnString = "http://www.foaas.com\(header)/\(firstKeyWord)/\(secondKeyWord)/\(thirdKeyWord)"
        default:
            returnString = "http://www.foaas.com\(header)"
        }
        return returnString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
  
  
    // this function never actually gets called because you never set the textField's delegate property
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstTextField:
            self.firstKeyWord = textField.text!
        case secondTextField:
            self.secondKeyWord = textField.text!
        case thirdTextField:
            self.thirdKeyWord = textField.text!
        default:
            print("smile")
        }
        updatePreview()
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        //send foaas to view controller
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: [ "foaas" : self.foaas! ])
        
        dismiss(animated: true, completion: nil)
    }

}
