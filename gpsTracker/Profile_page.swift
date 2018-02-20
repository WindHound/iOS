//
//  Profile.swift
//  gpsTracker
//
//  Created by 신종훈 on 19/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Profile_page: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    var fromwhere : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true
        self.toolbar.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Back_button_clicked(_ sender: Any) {
        if fromwhere == "Championship" {
            performSegue(withIdentifier: "Back_To_Champ", sender: self)
        }
        if fromwhere == "Event" {
            performSegue(withIdentifier: "Back_To_Event", sender: self)
        }
        if fromwhere == "Race" {
            performSegue(withIdentifier: "Back_To_Race", sender: self)
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
