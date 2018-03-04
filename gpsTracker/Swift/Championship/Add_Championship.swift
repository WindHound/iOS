//
//  Add_Championship.swift
//  WindHound
//
//  Created by 신종훈 on 27/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit


class Add_Championship: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Save_button: UIBarButtonItem!
    @IBOutlet weak var New_Event_button: UIButton!
    
    @IBOutlet weak var Name: UITextField!
    
    var activeTextfield : UITextField!
    
    @IBOutlet weak var Selected_Events_Table: UITableView!
    
    var Selected_Events : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.delegate = self
        
        Save_button.isEnabled = false
        
        New_Event_button.isEnabled = false
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
        if textField == Name {
            Save_button.isEnabled = false
            New_Event_button.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == Name {
            if Name.text != "" {
                Save_button.isEnabled = true
                New_Event_button.isEnabled = true
            } else {
                Save_button.isEnabled = false
                New_Event_button.isEnabled = false
            }
        }
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
            self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.bounds.width, height: self.view.bounds.height)}, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Name.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Selected_Events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Events", for: indexPath)
        
        cell.textLabel?.text = Selected_Events.object(at: indexPath.row) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Existing Event" {
            let secondViewController = segue.destination as! Existing_events
        
            secondViewController.Already_added = self.Selected_Events
        }
        
        if destination == "To Add Event" {
            let secondViewController = segue.destination as! Add_Event
            
            secondViewController.fromwhere = "Add Championship"
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            Selected_Events.removeObject(at: indexPath.row)
            tableView.reloadData()
        }
    }

    @IBAction func unwindToAddChamp(segue:UIStoryboardSegue) { }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
