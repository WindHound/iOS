//
//  event_information.swift
//  gpsTracker
//
//  Created by David Shin on 10/02/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit
import MapKit

class event_information: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var raceTitle: UILabel!
    
    @IBOutlet weak var Edit_button: UIBarButtonItem!
    @IBOutlet weak var Mutipurpose_button: UIBarButtonItem!
    
    @IBOutlet weak var Boat_Label: UILabel!
    @IBOutlet weak var Race_name: UILabel!
    
    @IBOutlet weak var Boat: UITextField!
    @IBOutlet weak var RaceDate: UITextField!
    @IBOutlet weak var StartTime: UITextField!
    @IBOutlet weak var EndTime: UITextField!
    
    
    var Chosen_Boat : Int = 0
    
    var UpOrHis : String = ""
    var fromwhere : String = ""
    
    var raceID : Int = 0
    var name : String = ""
    var boatID : [Int] = []
    var startDate : Int = 0
    var endDate : Int = 0
    
//    var perform : Bool = false
    
    private var race_struct : Race_Struct? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.clipsToBounds = true
        Race_name.text = name
        
        print(fromwhere)
        print(UpOrHis)
        
        Boat.delegate = self
        
        let DateStart = Date(timeIntervalSince1970: TimeInterval(startDate/1000))
        let DateEnd = Date(timeIntervalSince1970: TimeInterval(endDate/1000))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"

        let date = dateformatter.string(from: DateStart)
        let starttime = timeformatter.string(from: DateStart)
        let endtime = timeformatter.string(from: DateEnd)
        
        RaceDate.text = date
        StartTime.text = starttime
        EndTime.text = endtime
        
        if UpOrHis == "History" {
            Edit_button.isEnabled = false
            Edit_button.tintColor = UIColor.clear
            Mutipurpose_button.title = "Replay"
            Boat_Label.text = "Recorded Boat"
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func Mutipurpose_button_pressed(_ sender: Any) {
        
        if Mutipurpose_button.title == "Record" {
            if Boat.text == "" {
                createAlert(title: "Error", message: "Please choose a boat to record", name: "error")
            } else {
                performSegue(withIdentifier: "To Record", sender: self)
            }
        }
        
        if Mutipurpose_button.title == "Replay" {
            if Boat.text == "" {
                createAlert(title: "Error", message: "Please choose a boat to replay", name: "error")
            } else {
                getMoveData()
                while (race_struct == nil) {
                    
                }
                performSegue(withIdentifier: "To Replay", sender: self)
            }
        }
    }
    
    func getMoveData() {
        let dataURL = "movedata/get/"
        
        let jsonUrlString = URL(string: "\(baseURL)\(dataURL)\(raceID)/\(Chosen_Boat)")
        
        print(jsonUrlString as Any)
        
        let session = URLSession.shared
        session.dataTask(with: jsonUrlString!, completionHandler: {(data, response, error) -> Void in
            guard let data = data else {return}
            
            do {
//                let moveData = try JSONSerialization.jsonObject(with: data, options: [])
                let moveData = try JSONDecoder().decode([sailboat].self, from: data)
//                print(moveData)
                
//                for i in 0...moveData.count - 1 {
//                    print(moveData[i])
//                }
                print("1")
                let newRace = Race_Struct(context: CoreDataStack.context)
                print("2")
                newRace.distance = 0
                print("3")
                newRace.duration = Int64(moveData[moveData.count - 1].timeMilli - moveData[0].timeMilli)
                print("4")
                
                newRace.timestamp = Date(timeIntervalSince1970: TimeInterval(self.startDate / 1000))
                print("5")
                for location in moveData {
                    print("I'm here")
                    let locationObject = Location_Struct(context: CoreDataStack.context)
                    locationObject.timestamp = Date(timeIntervalSince1970: TimeInterval(location.timeMilli))
                    locationObject.latitude = location.latitude
                    locationObject.longitude = location.longitude
                    newRace.addToLocations(locationObject)
                    
                }
                
                
                CoreDataStack.saveContext()
                
                self.race_struct = newRace
                
//                self.perform = true
                

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_button_pressed(_ sender: Any) {
        if fromwhere == "Race_List" {
            self.performSegue(withIdentifier: "Back_To_Race_List", sender: self)
        }
        
        if fromwhere == "Race" {
            self.performSegue(withIdentifier: "Back To Race", sender: self)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == Boat {
            performSegue(withIdentifier: "To Related Boat", sender: self)
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Related Boat" {
            let secondViewController = segue.destination as! Related_Boats
            secondViewController.Boats = self.boatID
        }
        
        if destination == "To Record" {
            let secondViewController = segue.destination as! GpsAndSensor
            secondViewController.raceID = raceID
            secondViewController.boatID = Chosen_Boat
        }
    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "error" {
                
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
    
    
    @IBAction func unwindToRaceInformation(segue:UIStoryboardSegue) { }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
