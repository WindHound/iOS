//
//  add_event.swift
//  gpsTracker
//
//  Created by 신종훈 on 29/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Add_event: UIViewController {

    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var textLocation: UITextField!
    
    @IBOutlet weak var textStartdate: UITextField!
    
    @IBOutlet weak var textEnddate: UITextField!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    
    var activeTextField : UITextField!
    
    var initialdate : String!
    
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topToolBar.clipsToBounds = true
        
        textTitle.delegate = self
        textLocation.delegate = self
        
        // To repond when user presses date text fields
        createDatePicker(forField: textStartdate)
        createDatePicker(forField: textEnddate)
        
        // Initial start date when view is loaded
        let date = Date()
        
        let startformatter = DateFormatter()
        startformatter.dateStyle = .medium
        startformatter.timeStyle = .short
        
        textStartdate.text = "\(startformatter.string(from:date))"
        
        startformatter.timeStyle = .none
        
        initialdate = startformatter.string(from:date)
        
        // Initial end date when view is loaded
        let calendar = Calendar.current
        
        let hour = (calendar.component(.hour, from: date) + 1)
        let minute = calendar.component(.minute, from: date)
        
        textEnddate.text = "\(hour):\(minute)"
        
        
    }
    
    
    @IBAction func textStart_touched(_ sender: Any) {
        activeTextField = textStartdate
    }
    
    
    @IBAction func textEnd_touched(_ sender: Any) {
        activeTextField = textEnddate
    }
    
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
            startdateformatter.dateStyle = .medium
            startdateformatter.timeStyle = .short
            let startdateString = startdateformatter.string(from: picker.date)
            
            textStartdate.text = "\(startdateString)"
            
            startdateformatter.timeStyle = .none
            
            initialdate = startdateformatter.string(from: picker.date)
            
        }
        
        
        //End date
        if activeTextField == textEnddate {
            let enddateformatter = DateFormatter()
            enddateformatter.dateStyle = .medium
            enddateformatter.timeStyle = .none
            let comparedateString = enddateformatter.string(from: picker.date)
            
            if comparedateString == initialdate {
                enddateformatter.dateStyle = .none
            }
            enddateformatter.timeStyle = .short
            let enddateString = enddateformatter.string(from: picker.date)
            
            textEnddate.text = "\(enddateString)"
        }
        
        self.view.endEditing(true)
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension Add_event : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
