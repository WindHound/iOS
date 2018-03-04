//
//  Add_Event.swift
//  WindHound
//
//  Created by 신종훈 on 03/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Add_Event: UIViewController {
    
    var fromwhere : String = "Event"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
