//
//  Add_Event.swift
//  WindHound
//
//  Created by 신종훈 on 03/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Add_Event: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var fromwhere : String = "Event"

    @IBOutlet weak var Selected_Admins_Table: UITableView!
    @IBOutlet weak var Selected_Championships_Table: UITableView!
    @IBOutlet weak var Selected_Races_Table: UITableView!
    
    var Selected_Admins : NSMutableArray = []
    var Selected_Championships : NSMutableArray = []
    var Selected_Races : NSMutableArray = []
    
    @IBOutlet weak var Save_button: UIBarButtonItem!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Start_date: UITextField!
    @IBOutlet weak var End_Date: UITextField!
    
    var startdate : String = ""
    var enddate : String = ""
    var currentdate : String = ""
    
    var activeTextfield : UITextField!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.delegate = self
        Start_date.delegate = self
        End_Date.delegate = self
    
        Save_button.isEnabled = false
        
        createDatePicer(forField: Start_date)
        createDatePicer(forField: End_Date)
        
        let date = Date()
        
        let currentdateformatter = DateFormatter()
        currentdateformatter.dateFormat = "yyyy-MM-dd"
        
        currentdate = currentdateformatter.string(from: date)

        // Do any additional setup after loading the view.
    }
    
    func createDatePicer(forField field : UITextField) {
        let datetoolbar = UIToolbar()
        datetoolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        datetoolbar.setItems([done], animated: false)
        
        field.inputAccessoryView = datetoolbar
        field.inputView = picker
        
    }
    
    @objc func donePressed() {
        
        //Start date
        if activeTextfield == Start_date {
            let startdateformatter = DateFormatter()
            startdateformatter.dateFormat = "yyyy-MM-dd"
            
            let startdateString = startdateformatter.string(from: picker.date)
            
            startdate = startdateString
            
            if startdate < currentdate {
                createAlert(title: "Invalid date", message: "Start date can't be before today.", name: "Start date")
            }
            Start_date.text = "\(startdateString)"
        }
        
        // End date
        if activeTextfield == End_Date {
            let enddateformatter = DateFormatter()
            enddateformatter.dateFormat = "yyyy-MM-dd"
            
            let enddateString = enddateformatter.string(from: picker.date)
            
            enddate = enddateString
            
            if enddate < startdate {
                createAlert(title: "Invalid date", message: "End date can't be before start date", name: "End date")
            } else {
                End_Date.text = "\(enddateString)"
            }
        }
        
        self.view.endEditing(true)
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
        if tableView == Selected_Admins_Table {
            return Selected_Admins.count
        }
        if tableView == Selected_Championships_Table {
            return Selected_Championships.count
        }
        return Selected_Races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == Selected_Admins_Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Admins", for: indexPath)
            
            cell.textLabel?.text = Selected_Admins.object(at: indexPath.row) as? String
            
            return cell
        }
        
        if tableView == Selected_Championships_Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Championships", for: indexPath)
            
            cell.textLabel?.text = Selected_Championships.object(at: indexPath.row) as? String
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Races", for: indexPath)
        
        cell.textLabel?.text = Selected_Races.object(at: indexPath.row) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if tableView == Selected_Championships_Table {
                if (indexPath.row == 0) {
                    createAlert(title: "Denied", message: "You can not delete this championship", name: "Error")
                } else {
                    Selected_Championships.removeObject(at: indexPath.row)
                    tableView.reloadData()
                }
            }
            
            if tableView == Selected_Admins_Table {
                Selected_Admins.removeObject(at: indexPath.row)
            }
            
            if tableView == Selected_Races_Table {
                Selected_Races.removeObject(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel_Pressed(_ sender: Any) {
        if fromwhere == "Event" {
            performSegue(withIdentifier: "Back To Event", sender: self)
        }
        if fromwhere == "Add Championship" {
            performSegue(withIdentifier: "Back To Add Championship", sender: self)
        }
    }
    
    @IBAction func New_Race_Button_Pressed(_ sender: Any) {
        if Name.text == "" {
            createAlert(title: "Empty Event Name", message: "To create a new race, please enter event name", name: "Name")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Existing Admins" {
            let secondViewController = segue.destination as! Existing_Admins
            secondViewController.fromwhere = "Add Event"
            secondViewController.Already_added = Selected_Admins
        }
        
        if destination == "To Existing Champ" {
            let secondViewController = segue.destination as! Existing_Championship
            secondViewController.Already_added = Selected_Championships
        }
    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "Name" {
                self.Name.becomeFirstResponder()
            } else {
                if name == "End date" {
                    self.End_Date.becomeFirstResponder()
                } else {
                    if name == "Start date" {
                        self.Start_date.becomeFirstResponder()
                    }
                }
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
