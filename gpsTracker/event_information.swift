//
//  event_information.swift
//  gpsTracker
//
//  Created by David Shin on 10/02/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

class event_information: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var raceTitle: UILabel!
    
    @IBOutlet weak var Edit_button: UIBarButtonItem!
    @IBOutlet weak var Mutipurpose_button: UIBarButtonItem!
    
    var UpOrHis = ""
    var fromwhere = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.clipsToBounds = true
        
        print(fromwhere)
        print(UpOrHis)

        // Do any additional setup after loading the view.
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
