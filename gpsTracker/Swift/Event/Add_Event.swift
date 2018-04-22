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
    var Selected_Championships : [Championships] = []
    var Selected_Races : [Races] = []
    
    var admins : [Int] = []
    var championships : [Int] = []
    var races : [Int] = []
    
    @IBOutlet weak var Save_button: UIBarButtonItem!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Start_date: UITextField!
    @IBOutlet weak var End_Date: UITextField!
    
    var startdate : String = ""
    var enddate : String = ""
    var currentdate : String = ""
    
    var startdateMilli : Int = 0
    var enddateMilli : Int = 0
    
    var postURL : String = "structure/event/add"
    
    var id : Int? = nil
    
    var eventToAdd = Events(id: nil, name: "", startDate: 0, endDate: 0, admins: [], championships: [], races: [])
    
    var activeTextfield : UITextField!
    
    let picker = UIDatePicker()
    
    var addPressed : Bool = false
    
    var toolBarName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.datePickerMode = UIDatePickerMode.date
        
        self.navigationItem.title = toolBarName
        
        Name.delegate = self
        Start_date.delegate = self
        End_Date.delegate = self
    
        Save_button.isEnabled = false
        addPressed = false
        
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
            startdateMilli = Int(TimeInterval(picker.date.timeIntervalSince1970 * 1000))
            
            if startdate < currentdate {
                createAlert(title: "Invalid date", message: "Start date can't be before today.", name: "Start date")
            }
            Start_date.text = startdateString
        }
        
        // End date
        if activeTextfield == End_Date {
            let enddateformatter = DateFormatter()
            enddateformatter.dateFormat = "yyyy-MM-dd"
            
            let enddateString = enddateformatter.string(from: picker.date)
            
            enddate = enddateString
            enddateMilli = Int(TimeInterval(picker.date.timeIntervalSince1970 * 1000))
            
            if enddate < startdate {
                createAlert(title: "Invalid date", message: "End date can't be before start date", name: "End date")
            } else {
                End_Date.text = enddateString
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
        Save_button.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if checkAddValid() {
            Save_button.isEnabled = true
        } else {
            Save_button.isEnabled = false
        }
    }
    
    func checkAddValid() -> Bool{
        if Name.text != "" && Start_date.text != "" && End_Date.text != "" {
            return true
        } else {
            return false
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
            
            cell.textLabel?.text = Selected_Championships[indexPath.row].name
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Races", for: indexPath)
        
        cell.textLabel?.text = Selected_Races[indexPath.row].name
        
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
                    Selected_Championships.remove(at: indexPath.row)
                }
            }
            
            if tableView == Selected_Admins_Table {
                Selected_Admins.removeObject(at: indexPath.row)
            }
            
            if tableView == Selected_Races_Table {
                Selected_Races.remove(at: indexPath.row)
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
        } else {
            if Start_date.text == "" {
            createAlert(title: "Empty Start Date", message: "To create a new event, please enter the start date", name: "Start Date")

            } else {
                if End_Date.text == "" {
                    createAlert(title: "Empty End Date", message: "To create a new event, please enter the end date", name: "End Date")
                }
            }
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
        
        if destination == "To Add Race" {
            let secondViewController = segue.destination as! Add_Race
            secondViewController.fromwhere = "Add Event"
            secondViewController.Selected_Events.append(eventToAdd)
            
            if Selected_Admins.count != 0 {
                secondViewController.Selected_Admins.addObjects(from: self.Selected_Admins as! [Any])
            }
            secondViewController.toolBarName = "Add Race "
        }
        
        if destination == "Back To Event" {
            if addPressed {
                let secondViewController = segue.destination as! Event_Master
                secondViewController.upcoming_event = []
                secondViewController.history_event = []
                
                if (id != nil) {
                    secondViewController.All_Event.append(id!)
                }
                secondViewController.updatearray()
            }
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
    
    @IBAction func Save_Pressed(_ sender: Any) {
        championships = []
        races = []
        if Selected_Championships.count != 0 {
            for i in 0...Selected_Championships.count - 1 {
                championships.append(Selected_Championships[i].id!)
            }
        }
        
        if Selected_Races.count != 0 {
            for i in 0...Selected_Races.count - 1 {
                races.append(Selected_Races[i].id)
            }
        }
        
        print(championships)
        print(races)
        add()
        addPressed = true
        while (id == nil) {
            
        }
        
        if fromwhere == "Add Championship" {
            performSegue(withIdentifier: "Back To Add Championship", sender: self)
        } else {
            performSegue(withIdentifier: "Back To Event", sender: self)
        }
    }
    
    func add() {
        eventToAdd.name = Name.text!
        eventToAdd.startDate = startdateMilli
        eventToAdd.endDate = enddateMilli
        eventToAdd.championships = self.championships
        eventToAdd.races = self.races
        
        guard let jsonData = try? JSONEncoder().encode(eventToAdd) else {return}
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) else {return}
        
        print(json)
        
        guard let url = URL (string: "\(baseURL)\(postURL)") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    self.eventToAdd.id = json as? Int
                    self.id = json as? Int
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        }.resume()
        
        
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
