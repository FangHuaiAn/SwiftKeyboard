//
//  ViewController.swift
//  SwiftKeyboard
//
//  Created by 房懷安 on 2020/5/26.
//  Copyright © 2020 房懷安. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    // MARK: - UI
    
    @IBOutlet weak var btnGoBottomConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var myWebView: WKWebView!
    
    @IBOutlet weak var txtUrl: UITextField!
    
    // MARK: - UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillAppear(keyboardShowNotification:)),
        name: UIResponder.keyboardDidShowNotification,
        object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func btnGoClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        //self.myWebView.load(URLRequest(url: URL(string: "https://www.google.com/")!))
        
        self.myWebView.load(URLRequest(url: URL(string: "https://\( self.txtUrl.text! ))")!))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextField
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.view.endEditing(true)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Spec. Acceptable Char.
        let accept = "abcdefghijklmnopqrstuvwxyxABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()=+-<>?"
        let cs = NSCharacterSet(charactersIn: accept).inverted
    
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        if( string != filtered){
            return false
        }
        
        // Max Length
        let maxLength : Int = 10
        
        let currentString : NSString = textField.text! as NSString
        
        let newString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= maxLength
        
    }

    
    
    @objc func keyboardWillAppear(keyboardShowNotification notification: Notification ) {
        
        
        // 1
        if let userInfo = notification.userInfo,
            // 2
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        {
            print("Keyboard Height:\( keyboardRectangle.height) ")
            DispatchQueue.main.async {
                self.btnGoBottomConstaint.constant = keyboardRectangle.height
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification:  Notification ) {
        DispatchQueue.main.async {
            self.btnGoBottomConstaint.constant = 0
        }
    }


}

