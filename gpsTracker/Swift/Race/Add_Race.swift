//
//  add_event.swift
//  gpsTracker
//
//  Created by David Shin on 29/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

struct Race_To_Post : Encodable {
    var id : Int?
    var name : String
    var boats : [Int] // Boat
    var events : [Int] // Event
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
    
    var requestURL : String = "structure/race/add"
    
    var eventURL : String = "structure/event/get/"
    var boatURL : String = "structure/boat/get/"

    var Selected_Events : [Events] = []
    var Selected_Admins : NSMutableArray = []
    var Selected_Boats : [Boats_Post] = []
    
    var events : [Int] = []
    var admins : [Int] = []
    var boats : [Int] = []
    
    @IBOutlet weak var Selected_Admins_Table: UITableView!
    @IBOutlet weak var Selected_Events_Table: UITableView!
    
    var id : Int? = nil
    
    var raceToAdd = Race_To_Post(id: nil, name:"" , boats: [], events: [], admins: [], startDate: 0, endDate: 0)
    
    var startdateMilli : Int = 0
    var enddateMilli : Int = 0
    
    var addPressed : Bool = false
    
    var toolBarName : String = ""

    @IBOutlet weak var add_button: UIBarButtonItem!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPressed = false
        
        textTitle.delegate = self
        textLocation.delegate = self
        textStartdate.delegate = self
        textEnddate.delegate = self
        textRace.delegate = self
        add_button.isEnabled = false
        
        textTitle.text = raceToAdd.name
        
        if (raceToAdd.startDate != 0) {
            let dateformatter = DateFormatter()
            
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let startdate = Date(timeIntervalSince1970: TimeInterval(raceToAdd.startDate/1000))
            
            let enddate = Date(timeIntervalSince1970: TimeInterval(raceToAdd.endDate/1000))
            
            let startdateString = dateformatter.string(from:startdate)
            let enddateString = dateformatter.string(from: enddate)
            
            textStartdate.text = startdateString
            textEnddate.text = enddateString
            
            startdateMilli = raceToAdd.startDate
            enddateMilli = raceToAdd.endDate
        }
        
        if raceToAdd.boats != [] {
            updateBoat()
        }
        
        if raceToAdd.events != [] {
            updateEvent()
        }
        
        self.navigationItem.title = toolBarName
        
        
        // To repond when user presses date text fields
        createDatePicker(forField: textStartdate)
        createDatePicker(forField: textEnddate)
        
        // Initial start date when view is loaded
        let date = Date()
        
        let currentdateformatter = DateFormatter()
        currentdateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        currenttime = currentdateformatter.string(from: date)
        
    }
    
    func updateEvent() {
        for i in 0...(self.raceToAdd.events.count - 1) {
            let jsonUrlString = URL(string: "\(baseURL)\(eventURL)\(self.raceToAdd.events[i])")
            
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
    
    func updateBoat() {
        for i in 0...(self.raceToAdd.boats.count - 1){
            let jsonUrlString = URL(string:"\(baseURL)\(boatURL)\(self.raceToAdd.boats[i])")
            
            let session = URLSession.shared
            session.dataTask(with: jsonUrlString!, completionHandler: {(data, response, error) -> Void in
                guard let data = data else {return}
                
                do {
                    let boat = try JSONDecoder().decode(Boats_Post.self, from: data)
                    
                    print(boat)
                    
                    self.Selected_Boats.append(boat)
                    
                    DispatchQueue.main.async{
                        self.textRace.text = String(self.Selected_Boats.count)
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
            startdateMilli = Int(TimeInterval(picker.date.timeIntervalSince1970 * 1000))
            
            if starttime < currenttime {
                createAlert(title: "Invalid date", message: "Start date can't be before today", name: "Start date")
            } else {
                textStartdate.text = startdateString
            }
        }


        //End date
        if activeTextField == textEnddate {
            let enddateformatter = DateFormatter()
            enddateformatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            let enddateString = enddateformatter.string(from: picker.date)
            
            endtime = enddateString
            enddateMilli = Int(TimeInterval(picker.date.timeIntervalSince1970 * 1000))
            
            if endtime < starttime {
                createAlert(title: "Invalid date", message: "End date can't be before start date" , name: "End date")
            } else {
                textEnddate.text = enddateString
                
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Events", for: indexPath)
            
        cell.textLabel?.text = Selected_Events[indexPath.row].name
            
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
            
            secondViewController.Added_Boats = self.Selected_Boats
        }
        
        if destination == "Back To Race" {
            if addPressed {
                let secondViewController = segue.destination as! Race_Master
                
                secondViewController.upcoming_race = []
                secondViewController.history_race = []
                if (id != nil && toolBarName != "Edit Race") {
                    secondViewController.All_Races.append(id!)
                }
                secondViewController.updatearray()
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        add_button.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if checkAddValid() {
            add_button.isEnabled = true
        } else {
            add_button.isEnabled = false
        }
    }
    
    func checkAddValid() -> Bool {
        if textTitle.text != "" && textStartdate.text != "" && textEnddate.text != "" {
            return true
        } else {
            return false
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
                add_button.isEnabled = true
                Selected_Events.remove(at: indexPath.row)
            }
            
            if tableView == Selected_Admins_Table {
                Selected_Admins.removeObject(at: indexPath.row)
            }
            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToAddRace(segue:UIStoryboardSegue) { }

    
    @IBAction func Add_Pressed(_ sender: Any) {
        events = []
        admins = []
        boats = []
        
        if Selected_Events.count != 0 {
            for i in 0...Selected_Events.count - 1 {
                events.append(Selected_Events[i].id!)
            }
        }
        
        if Selected_Boats.count != 0 {
            for i in 0...Selected_Boats.count - 1 {
                boats.append(Selected_Boats[i].id!)
            }
        }
        
        print(events)
        print(boats)
        
        add()
        addPressed = true
        while (id == nil) {
            
        }
        if fromwhere == "Add Event" {
            performSegue(withIdentifier: "Back To Add Event", sender: self)
        } else {
            performSegue(withIdentifier: "Back To Race", sender: self)
        }
    }
    
    func add() {
        raceToAdd.name = textTitle.text!
        raceToAdd.startDate = startdateMilli
        raceToAdd.endDate = enddateMilli
        raceToAdd.events = self.events
        raceToAdd.boats = self.boats
        
        guard let jsonData = try? JSONEncoder().encode(raceToAdd) else {return}
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) else {return}
        
        print(json)
        
        guard let url = URL(string: "\(baseURL)\(requestURL)") else {return}
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
                    self.raceToAdd.id = json as? Int
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
