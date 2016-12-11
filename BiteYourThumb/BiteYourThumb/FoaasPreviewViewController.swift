//
//  FoaasPreviewViewController.swift
//  BiteYourThumb
//
//  Created by Tong Lin on 11/27/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class FoaasPreviewViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var singleTappedGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!

    @IBOutlet weak var foulLanguageSwitch: UISwitch!
    @IBOutlet weak var bottomOfScrollView: NSLayoutConstraint!
    let listOfFoulWords = ["darn", "crap", "newb", "fuck", "dam", "fucking", "shit"]
    
    let notificationCenter = NotificationCenter.default
    var operation: FoaasOperation?
    var pathBuilder: FoaasPathBuilder!
    var foaas : Foaas?
    var clearnFoaas: Foaas?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstTextField.delegate = self
        self.secondTextField.delegate = self
        self.thirdTextField.delegate = self
        self.navigationItem.title = self.operation?.name
        
        self.pathBuilder = FoaasPathBuilder(operation: self.operation!)
        setupView()
        loadFoaas()
        
        notificationCenter.addObserver(self, selector: #selector(willShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Navigation
    
    func willShow(sender: NSNotification){
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomOfScrollView.constant == 0{
                self.bottomOfScrollView.constant += keyboardSize.height
                self.scrollView.updateConstraints()
            }
        }
    }
    
    func willHide(sender: NSNotification){
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomOfScrollView.constant > 0{
                self.bottomOfScrollView.constant -= keyboardSize.height
                self.scrollView.updateConstraints()
            }
        }
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
        case 2:
            print("need 2 text fields")
            self.firstLabel.text = self.operation?.fields[0].name
            self.firstTextField.placeholder = self.operation?.fields[0].name
            self.secondLabel.text = self.operation?.fields[1].name
            self.secondTextField.placeholder = self.operation?.fields[1].name
            self.thirdLabel.isHidden = true
            self.thirdTextField.isHidden = true
        case 3:
            print("need 3 text fields")
            self.firstLabel.text = self.operation?.fields[0].name
            self.firstTextField.placeholder = self.operation?.fields[0].name
            self.secondLabel.text = self.operation?.fields[1].name
            self.secondTextField.placeholder = self.operation?.fields[1].name
            self.thirdLabel.text = self.operation?.fields[2].name
            self.thirdTextField.placeholder = self.operation?.fields[2].name
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

    func loadFoaas(){
        FoaasDataManager.shared.requestFoaas(endpoint: "http://www.foaas.com\(self.pathBuilder.build())"){ (foaas: Foaas?) in
            if foaas != nil{
                DispatchQueue.main.async {
                    self.foaas = foaas
                    self.clearnFoaas = self.languageFilter()
                    self.updatePreviewLabel()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstTextField:
            self.pathBuilder.update(key: (self.operation?.fields[0].field)!, value: textField.text!)
        case secondTextField:
            self.pathBuilder.update(key: (self.operation?.fields[1].field)!, value: textField.text!)
        case thirdTextField:
            self.pathBuilder.update(key: (self.operation?.fields[2].field)!, value: textField.text!)
        default:
            print("smile")
        }
        textField.resignFirstResponder()
        self.view.endEditing(true)
        loadFoaas()
        return true
    }
    
    func languageFilter() -> Foaas{
        var message = ""
        var subtitle = ""
        func cleanString(with: String) -> String{
            var filteredWrod = ""
            var count = 0
            let set: CharacterSet = ["a", "e", "i", "o", "u"]
            for char in with.characters{
                if count == 0 && set.contains(UnicodeScalar(String(char).lowercased())!){
                    filteredWrod += "*"
                    count += 1
                }else{
                    filteredWrod += String(char)
                }
            }
            return filteredWrod
        }
        
        for word in (self.foaas?.message.components(separatedBy: " "))!{
            message += "\(self.listOfFoulWords.contains(word.lowercased()) ? cleanString(with: word) : word) "
        }
        for word in (self.foaas?.subtitle.components(separatedBy: " "))!{
            subtitle += "\(self.listOfFoulWords.contains(word.lowercased()) ? cleanString(with: word) : word) "
        }
        //self.foaas = Foaas(message: message, subtitle: subtitle)
        return Foaas(message: message, subtitle: subtitle)
    }
    
    func updatePreviewLabel(){
        self.previewLabel.text = self.foulLanguageSwitch.isOn ? ((self.clearnFoaas?.message)! + "\n" + (self.clearnFoaas?.subtitle)!) : ((self.foaas?.message)! + "\n" + (self.foaas?.subtitle)!)
    }
    
    @IBAction func didPerformGesture(_ sender: UIGestureRecognizer){
        switch sender {
        case singleTappedGesture:
            self.view.endEditing(true)
        default:
            print("Nothing happens")
        }
    }
    
    @IBAction func languageFilter(_ sender: UISwitch) {
        updatePreviewLabel()
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        //send foaas to view controller
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: ["foaas" : (self.foulLanguageSwitch.isOn ? self.clearnFoaas : self.foaas)!])
        
        dismiss(animated: true, completion: nil)

    }
}
