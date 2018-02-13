//
//  event_information.swift
//  gpsTracker
//
//  Created by 신종훈 on 10/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class event_information: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var raceTitle: UILabel!
    
    var fromwhere = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_button_pressed(_ sender: Any) {
        if fromwhere == "Upcoming_race" {
            self.performSegue(withIdentifier: "unwindToUpRaceList", sender: self)
        }
        
        if fromwhere == "History_race" {
            self.performSegue(withIdentifier: "unWindToHistRaceList", sender: self)
        }
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
