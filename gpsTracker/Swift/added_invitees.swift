//
//  added_invitees.swift
//  gpsTracker
//
//  Created by 신종훈 on 03/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class added_invitees: UIViewController {
    
    var invitees : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make back button color to white
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
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
