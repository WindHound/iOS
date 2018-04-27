//
//  Add_Championship.swift
//  WindHound
//
//  Created by 신종훈 on 27/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

struct Championship_Post : Encodable {
    var id : Int?
    var name : String
    var startDate : Int
    var endDate : Int
    var admins : [Int]
    var events : [Int]
}

class Add_Championship: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Save_button: UIBarButtonItem!
    @IBOutlet weak var New_Event_button: UIButton!
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Start_date: UITextField!
    @IBOutlet weak var End_date: UITextField!
    
    var startdate : String = ""
    var enddate : String = ""
    var currentdate : String = ""
    
    var startdateMilli : Int = 0
    var enddateMilli : Int = 0
    
    var postURL : String = "structure/championship/add"
    
    var specificURL : String = "structure/event/get/"
    
    var id : Int? = nil
    
    var championshipToAdd = Championship_Post(id: nil, name: "", startDate: 0, endDate: 0, admins: [], events: [])
    
    var activeTextfield : UITextField!
    
    let picker = UIDatePicker()
    
    @IBOutlet weak var Selected_Events_Table: UITableView!
    @IBOutlet weak var Selected_Admins_Table: UITableView!
    
    var Selected_Events : [Events] = []
    
    var Selected_Admins : NSMutableArray = []
    
    var events : [Int] = []
    var admins : [Int] = []
    
    var addPressed : Bool = false
    
    var toolBarName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = toolBarName
        
        picker.datePickerMode = UIDatePickerMode.date
        
        Name.delegate = self
        Start_date.delegate = self
        End_date.delegate = self
        
        Name.text = championshipToAdd.name
        if championshipToAdd.startDate != 0 {
            
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "yyyy-MM-dd"
            
            let startdate = Date(timeIntervalSince1970: TimeInterval(championshipToAdd.startDate/1000))
            
            startdateMilli = championshipToAdd.startDate
            
            let enddate = Date(timeIntervalSince1970: TimeInterval(championshipToAdd.endDate/1000))
            
            enddateMilli = championshipToAdd.endDate
            
            let startdateString = dateformatter.string(from: startdate)
            let enddateString = dateformatter.string(from: enddate)
            
            
            Start_date.text = startdateString
            End_date.text = enddateString
        }
        
        
        if championshipToAdd.events != [] {
            updateEvent()
        }
        
        Save_button.isEnabled = false
        addPressed = false
        
        createDatePicer(forField: Start_date)
        createDatePicer(forField: End_date)
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let date = Date()
        
        let currentdateformatter = DateFormatter()
        currentdateformatter.dateFormat = "yyyy-MM-dd"

        
        currentdate = currentdateformatter.string(from: date)

        // Do any additional setup after loading the view.
    }
    
    func updateEvent() {
        for i in 0...(self.championshipToAdd.events.count - 1) {
            let jsonUrlString = URL(string: "\(baseURL)\(specificURL)\(self.championshipToAdd.events[i])")
            
            let session = URLSession.shared
            session.dataTask(with: (jsonUrlString!), completionHandler: {(data, response, error) -> Void in
                guard let data = data else {return}
                
                do {
                    let event = try JSONDecoder().decode(Events.self, from: data)
                    
                    print(event)
                    
                    self.Selected_Events.append(event)
                    
                    DispatchQueue.main.async {
                        self.Selected_Events_Table.reloadData()
                    }
                } catch {
                    print(error)
                }
                
                if let response = response {
                    print(response)
                }
                
                if let error = error {
                    print(error)
                }
            }).resume()
        }
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
        if activeTextfield == End_date {
            let enddateformatter = DateFormatter()
            enddateformatter.dateFormat = "yyyy-MM-dd"

            let enddateString = enddateformatter.string(from: picker.date)
            
            enddate = enddateString
            enddateMilli = Int(TimeInterval(picker.date.timeIntervalSince1970 * 1000))
            
            if enddate < startdate {
                createAlert(title: "Invalid date", message: "End date can't be before start date", name: "End date")
            } else {
                 End_date.text = enddateString
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
        if Name.text != "" && Start_date.text != "" && End_date.text != "" {
            return true
        } else {
            return false
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
        if tableView == Selected_Admins_Table {
            return Selected_Admins.count
        }
        return Selected_Events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == Selected_Admins_Table {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Admins", for: indexPath)
            
            cell.textLabel?.text = Selected_Admins.object(at: indexPath.row) as? String
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Events", for: indexPath)
        
        cell.textLabel?.text = Selected_Events[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Existing Event" {
            let secondViewController = segue.destination as! Existing_events
        
            secondViewController.fromwhere = "Add Championship"
            secondViewController.Already_added = self.Selected_Events
        }
        
        if destination == "To Add Event" {
            let secondViewController = segue.destination as! Add_Event
            
            secondViewController.fromwhere = "Add Championship"
            
//            secondViewController.Selected_Championships.add(Name.text as Any)
            
            if Selected_Admins.count != 0 {
                secondViewController.Selected_Admins.addObjects(from: self.Selected_Admins as! [Any])
            }
        
            secondViewController.toolBarName = "Add Event"
        }
    
        if destination == "To Add Admins" {
            let secondViewController = segue.destination as! Existing_Admins
            
            secondViewController.fromwhere = "Add Championship"
            
            secondViewController.Already_added = Selected_Admins
        }
        
        if destination == "Back To Champ" {
            if addPressed {
                let secondViewController = segue.destination as! Championship_Master
                secondViewController.upcoming_champ = []
                secondViewController.history_champ = []
                if (id != nil && toolBarName != "Edit Championship") {
                    secondViewController.All_Championship.append(id!)
                }
                secondViewController.updatearray()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            Selected_Events.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
//    @IBAction func New_Events_Button_Pressed(_ sender: Any) {
//        if Name.text == "" {
//            createAlert(title: "Empty Championship Name", message: "To create a new event, please enter championship name", name: "Name")
//        } else {
//            if Start_date.text == "" {
//                createAlert(title: "Empty Start Date", message: "To create a new event, please enter the start date", name: "Start Date")
//            } else {
//                if End_date.text == "" {
//                    createAlert(title: "Empty End Date", message: "To create a new event, please enter the end date", name: "End Date")
//                }
//            }
//        
//        }
//    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "Name" {
                self.Name.becomeFirstResponder()
            } else {
                if name == "End date" {
                    self.End_date.becomeFirstResponder()
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

    @IBAction func unwindToAddChamp(segue:UIStoryboardSegue) { }
    

    @IBAction func Save_Pressed(_ sender: Any) {
        events = []
        if Selected_Events.count != 0 {
            for i in 0...Selected_Events.count - 1 {
                events.append(Selected_Events[i].id!)
            }
        }
        print(events)
        add()
        addPressed = true
        while(id == nil) {

        }
        
        performSegue(withIdentifier: "Back To Champ", sender: self)
    }
    
    func add() {
        championshipToAdd.name = Name.text!
        championshipToAdd.startDate = startdateMilli
        championshipToAdd.endDate = enddateMilli
        championshipToAdd.events = self.events
        
        guard let jsonData = try? JSONEncoder().encode(championshipToAdd) else {return}
        
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
                    self.championshipToAdd.id = json as? Int
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
