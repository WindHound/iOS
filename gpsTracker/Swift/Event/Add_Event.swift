//
//  Add_Event.swift
//  WindHound
//
//  Created by 신종훈 on 03/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Add_Event: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var fromwhere : String = "Event"

    @IBOutlet weak var Save_button: UIBarButtonItem!
    
    @IBOutlet weak var Name: UITextField!
    
    var activeTextfield : UITextField!
    
    @IBOutlet weak var Selected_Championships: UITableView!
    
    @IBOutlet weak var Selected_Races: UITableView!
    
    var championships : NSMutableArray = []
    
    var races : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.delegate = self
        
        Save_button.isEnabled = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
        if textField == Name {
            Save_button.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == Name {
            if Name.text != "" {
                Save_button.isEnabled = true
            } else {
                Save_button.isEnabled = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Name.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == Selected_Championships {
            return championships.count
        }
        return races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == Selected_Championships {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Championships", for: indexPath)
            
            cell.textLabel?.text = championships.object(at: indexPath.row) as? String
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Races", for: indexPath)
    
        cell.textLabel?.text = races.object(at: indexPath.row) as? String
            
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if tableView == Selected_Championships {
                if (indexPath.row == 0) {
                    createAlert(title: "Denied", message: "You can't delete this championship", name: "Error")
                } else {
                    championships.removeObject(at: indexPath.row)
                    Selected_Championships.reloadData()
                }
            }
            if tableView == Selected_Races {
                races.removeObject(at: indexPath.row)
                Selected_Races.reloadData()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func New_Race_Button_Pressed(_ sender: Any) {
        if (Name.text == "") {
            createAlert(title: "Empty Event name", message: "To create a new race, please enter event name", name: "Name")
        }
    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "Name" {
                self.Name .becomeFirstResponder()
            }
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        // Reference purpose
        //        let openAction = UIAlertAction(title: "Open Settings", style: .default) {(action) in
        //            if let url = URL(string: UIApplicationOpenSettingsURLString) {
        //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //            }
        //        }
    }
    
    @IBAction func Cancel_Pressed(_ sender: Any) {
        if fromwhere == "Event" {
            performSegue(withIdentifier: "Back To Event", sender: self)
        }
        if fromwhere == "Add Championship" {
            performSegue(withIdentifier: "Back To Add Championship", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Existing Championships" {
            let secondViewController = segue.destination as! Existing_Championship
            
            secondViewController.Already_added = self.championships
        }
        
        if destination == "To Existing Races" {
            let secondViewController = segue.destination as! Existing_Races
            
            secondViewController.Already_added = self.races
        }
    }
    
    @IBAction func unwindToAddEvent(segue:UIStoryboardSegue) { }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
