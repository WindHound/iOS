//
//  event_list.swift
//  gpsTracker
//
//  Created by 신종훈 on 24/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//
//

import UIKit

class event_list_admin: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolbar.clipsToBounds = true
    
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
    
    @IBAction func unwindToEventList(segue:UIStoryboardSegue) { }
    
    
    

}
