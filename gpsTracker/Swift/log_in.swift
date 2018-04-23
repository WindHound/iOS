//
//  log_in.swift
//  gpsTracker
//
//  Created by David Shin on 23/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

//var baseURL : String = "http://WindHoundServerApp-cloud2017n04.apaas.us2.oraclecloud.com:8080/"

var baseURL : String = "http://192.168.138.1:8080/"
//var baseURL : String = "http://192.168.137.1:8080/"
//var baseURL : String = "http://94.175.24.251:8080/"

class log_in: UIViewController {

    @IBOutlet weak var textUsername: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    var activeTextfield : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textUsername.delegate = self
        textPassword.delegate = self

        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                
        // Do any additional setup after loading the view.
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])[a-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat! = self.activeTextfield?.frame.origin.y
        
        // checking if the textfield is really hidden behind the keyboard
        
        if (editingTextFieldY > keyboardY - 60) {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x:0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)}, completion:nil)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)}, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgot_password_clicked(_ sender: Any) {
    }
    @IBAction func sign_up_clicked(_ sender: Any) {
        
        
    }
    
    @IBAction func log_in_clicked(_ sender: Any) {
        
//        let password = textPassword.text
//        
//        if (textUsername.text == "") {
//            createAlert(title: "Invalid Username", message: "Please try it again", name: "Username")
//        } else if (!isPasswordValid(password!)) {
//            createAlert(title: "Invalid password", message: "Your password length needs to be at least 8, and at least contain one digit", name: "Password")
//            textPassword.text = ""
//        }
//       
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textUsername.resignFirstResponder()
        textPassword.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "Username" {
                self.textUsername .becomeFirstResponder()
            } else if name == "Password" {
                self.textPassword.becomeFirstResponder()
            }
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindTologin(segue:UIStoryboardSegue) {}
    
}

extension log_in : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

