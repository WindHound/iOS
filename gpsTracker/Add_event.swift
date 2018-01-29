//
//  Add_event.swift
//  gpsTracker
//
//  Created by 신종훈 on 28/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Add_event: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var textTitle: UITextField!
    
    
    @IBOutlet weak var textLocation: UITextField!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.clipsToBounds = true
        
        textTitle.delegate = self
        textLocation.delegate = self
        
        createDatePicker()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePicker() {
        // toolbar
        let datetoolbar = UIToolbar()
        datetoolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        datetoolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = datetoolbar
        dateField.inputView = picker
        
        
    }
    
    @objc func donePressed() {
        // format date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: picker.date)
        
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textTitle.resignFirstResponder()
        textLocation.resignFirstResponder()
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
