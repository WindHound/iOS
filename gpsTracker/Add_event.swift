//
//  add_event.swift
//  gpsTracker
//
//  Created by 신종훈 on 29/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class add_event: UIViewController {

    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var textLocation: UITextField!
    
    @IBOutlet weak var textStartdate: UITextField!
    
    @IBOutlet weak var textEnddate: UITextField!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    
    
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topToolBar.clipsToBounds = true
        
        textTitle.delegate = self
        textLocation.delegate = self
        
        // To repond when user presses date text fields
        createDatePicker()
        
        // Initial start date when view is loaded
        let date = Date()
        
        let startformatter = DateFormatter()
        startformatter.dateStyle = .medium
        startformatter.timeStyle = .short
        
        textStartdate.text = "\(startformatter.string(from:date))"
        
        // Initial end date when view is loaded
        let calendar = Calendar.current
        
        let hour = (calendar.component(.hour, from: date) + 1)
        let minute = calendar.component(.minute, from: date)
        
        textEnddate.text = "\(hour):\(minute)"
        
        
    }
    
    func createDatePicker() {
        // toolbar
        let datetoolbar = UIToolbar()
        datetoolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        datetoolbar.setItems([done], animated: false)
        
        textStartdate.inputAccessoryView = datetoolbar
        textStartdate.inputView = picker
        
        textEnddate.inputAccessoryView = datetoolbar
        textEnddate.inputView = picker
        
        
    }
    
    @objc func donePressed() {
        // format date
        
        let startformatter = DateFormatter()
        startformatter.dateStyle = .medium
        startformatter.timeStyle = .short
        let startdateString = startformatter.string(from: picker.date)
        
        let initialformatter = DateFormatter()
        initialformatter.dateStyle = .medium
        initialformatter.timeStyle = .none
        let initialdateString = initialformatter.string(from: picker.date)
        
        
        textStartdate.text = "\(startdateString)"
        
        
        
        self.view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textTitle.resignFirstResponder()
        textLocation.resignFirstResponder()
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


extension add_event : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
