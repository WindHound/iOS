//
//  add_event.swift
//  gpsTracker
//
//  Created by David Shin on 29/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

struct Race_Post : Encodable {
    var id : Int?
    var name : String
    var subordinates : [Int]
    var managers : [Int]
    var admins : [Int]
    var startDate : Int
    var endDate : Int
//    var latitude : Double
//    var longitude : Double
}

//For event
//Long          a_id,
//String        a_name,
//Calendar      a_startDate,
//Calendar      a_endDate,
//HashSet<Long> a_admins,
//HashSet<Long> a_races,
//HashSet<Long> a_championships

class Add_Race: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textLocation: UITextField!
    @IBOutlet weak var textStartdate: UITextField!
    @IBOutlet weak var textEnddate: UITextField!
    @IBOutlet weak var textRace: UITextField!
    
    var latitude : Double!
    var longitude : Double!
    
    var activeTextField : UITextField!
    
    var starttime : String = ""
    var endtime : String = ""
    var currenttime : String = ""
    
    var fromwhere : String = ""
    
    var raceToAdd = Race_Post(id: 0 , name: "", subordinates: [], managers: [], admins: [], startDate: 0, endDate: 0)
    
    var requestURL : String = "structure/race/add"

    var Selected_Events : NSMutableArray = []
    var Selected_Admins : NSMutableArray = []
    var Selected_Boats : NSMutableArray = []
    
    @IBOutlet weak var Selected_Admins_Table: UITableView!
    @IBOutlet weak var Selected_Events_Table: UITableView!
    @IBOutlet weak var Selected_Boats_Table: UITableView!
    
    
    @IBOutlet weak var add_button: UIBarButtonItem!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestID()
        
        textTitle.delegate = self
        textLocation.delegate = self
        textStartdate.delegate = self
        textEnddate.delegate = self
        textRace.delegate = self
        add_button.isEnabled = false
        
        if Selected_Boats.count != 0 {
            textRace.text = "\(Selected_Boats.count)"
        }
        
        // To repond when user presses date text fields
        createDatePicker(forField: textStartdate)
        createDatePicker(forField: textEnddate)
        
        // Initial start date when view is loaded
        let date = Date()
        
        let currentdateformatter = DateFormatter()
        currentdateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        currenttime = currentdateformatter.string(from: date)
        
    }
    
    func requestID() {
        
        let parameters = ["id": raceToAdd.id as Any, "name": raceToAdd.name, "startDate": raceToAdd.startDate, "endDate": raceToAdd.endDate, "admins": raceToAdd.admins, "managers": raceToAdd.managers, "subordinates": raceToAdd.subordinates] as [String : Any] // where raceToAdd.id is null at this point

        guard let url = URL(string: "\(baseURL)\(requestURL)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        guard let jsonBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        request.httpBody = jsonBody

        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
        


    }

    
    //Function to create date picker
    func createDatePicker(forField field : UITextField) {
        // toolbar
        let datetoolbar = UIToolbar()
        datetoolbar.sizeToFit()

        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        datetoolbar.setItems([done], animated: false)

        field.inputAccessoryView = datetoolbar
        field.inputView =  picker


    }
    
    @objc func donePressed() {
        // format date

        // Start date
        if activeTextField == textStartdate {
            let startdateformatter = DateFormatter()
            startdateformatter.dateFormat = "yyyy-MM-dd HH:mm"
            let startdateString = startdateformatter.string(from: picker.date)

            starttime = startdateString
            
            if starttime < currenttime {
                createAlert(title: "Invalid date", message: "Start date can't be before today", name: "Start date")
            } else {
                textStartdate.text = "\(startdateString)"
            }
        }


        //End date
        if activeTextField == textEnddate {
            let enddateformatter = DateFormatter()
            enddateformatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let enddateString = enddateformatter.string(from: picker.date)
            
            endtime = enddateString
            
            if endtime < starttime {
                createAlert(title: "Invalid date", message: "End date can't be before start date" , name: "End date")
            } else {
                textEnddate.text = "\(enddateString)"
                
            }
        }
        
        self.view.endEditing(true)

    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "Name" {
                self.textTitle.becomeFirstResponder()
            } else {
                if name == "End date" {
                    self.textEnddate.becomeFirstResponder()
                } else {
                    if name == "Start date" {
                        self.textStartdate.becomeFirstResponder()
                    }
                }
            }
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    @IBAction func Cancel_Button_Pressed(_ sender: Any) {
        if fromwhere == "Race" {
            performSegue(withIdentifier: "Back To Race", sender: self)
        }
        if fromwhere == "Add Event" {
            performSegue(withIdentifier: "Back To Add Event", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textTitle.resignFirstResponder()
        textLocation.resignFirstResponder()
        textStartdate.resignFirstResponder()
        textEnddate.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == Selected_Admins_Table {
            return Selected_Admins.count
        }
        if tableView == Selected_Events_Table {
            return Selected_Events.count
        }
        return Selected_Boats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == Selected_Admins_Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Admins", for: indexPath)
            
            cell.textLabel?.text = Selected_Admins.object(at: indexPath.row) as? String
            
            return cell
        }
        if tableView == Selected_Events_Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Events", for: indexPath)
            
            cell.textLabel?.text = Selected_Events.object(at: indexPath.row) as? String
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Boats", for: indexPath)
        
        cell.textLabel?.text = Selected_Boats.object(at: indexPath.row) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Existing Admins" {
            let secondViewController = segue.destination as! Existing_Admins
            
            secondViewController.Already_added = self.Selected_Admins
            
            secondViewController.fromwhere = "Add Race"
        }
        
        if destination == "To Existing Events" {
            let secondViewController = segue.destination as! Existing_events
            
            secondViewController.Already_added = self.Selected_Events
            secondViewController.fromwhere = "Add Race"
        }
        
        if destination == "To Add Boat" {
            let secondViewController = segue.destination as! Add_Boat
            
//            secondViewController.Added_Boats = self.Selected_Boats
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField == textTitle {
            add_button.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textTitle {
            if textTitle.text != "" {
                add_button.isEnabled = true
            } else {
                add_button.isEnabled = false
            }
        }
    }
    
    // Function to display differnet view controller when the location text field is pressed
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textLocation {
            performSegue(withIdentifier: "location_clicked", sender: self)
            return false
        } else if textField == textRace {
            performSegue(withIdentifier: "To Add Boat", sender: self)
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            if tableView == Selected_Events_Table {
                if (indexPath.row == 0) {
                    createAlert(title: "Denied", message: "You can not delete this event", name: "Error")
                } else {
                    Selected_Events.removeObject(at: indexPath.row)
                }
            }
            
            if tableView == Selected_Admins_Table {
                Selected_Admins.removeObject(at: indexPath.row)
            }
            
            if tableView == Selected_Boats_Table {
                Selected_Boats.removeObject(at: indexPath.row)
            }
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToAddRace(segue:UIStoryboardSegue) { }

    
    @IBAction func Add_Pressed(_ sender: Any) {
        raceToAdd.name = textTitle.text!
        
//        if latitude != nil && longitude != nil {
//            raceToAdd.latitude = self.latitude
//            raceToAdd.longitude = self.longitude
//        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if endtime != "" {
            let convertedDate = formatter.date(from: endtime)
            let endServerTime =   TimeInterval((convertedDate?.timeIntervalSince1970)! * 1000)
            raceToAdd.endDate = Int(endServerTime)
        }
        
        if starttime != "" {
            let convertedDate = formatter.date(from: starttime)
            let startServerTime = TimeInterval((convertedDate?.timeIntervalSince1970)! * 1000)
            raceToAdd.startDate = Int(startServerTime)
        }
        
//        if Selected_Admins.count != 0 {
//            raceToAdd.admins = Selected_Admins
//        } This need extra work
        
//        if Selected_Boats.count != 0 {
//            raceToAdd.subordinates = Selected_Boats
//        }
        

//        func convertToUTC(dateToConvert:String) -> String {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyyy hh:mm a"
//            let convertedDate = formatter.date(from: dateToConvert)
//            formatter.timeZone = TimeZone(identifier: "UTC")
//            return formatter.string(from: convertedDate!)
//
//        }
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
