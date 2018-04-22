//
//  event_information.swift
//  gpsTracker
//
//  Created by David Shin on 10/02/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

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
    
    var Chosen_Boat : Int!
    
    var UpOrHis : String = ""
    var fromwhere : String = ""
    
    var raceID : Int = 0
    var name : String = ""
    var boatID : [Int] = []
    var startDate : Int = 0
    var endDate : Int = 0
    
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
            Boat.isUserInteractionEnabled = false
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
                performSegue(withIdentifier: "To Replay", sender: self)
            }
        }
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
