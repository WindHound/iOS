//
//  Upcoming_events.swift
//  gpsTracker
//
//  Created by 신종훈 on 13/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Upcoming_events: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var upcoming_event_list : [String] = []
    
    var fromwhere : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [add, search]
        
        upcoming_event_list.append("MVB")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(upcoming_event_list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = upcoming_event_list[indexPath.row]
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Upcoming_race", sender: self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextscreen = segue.identifier
        
        if (nextscreen == "Upcoming_race") {
            let secondViewController = segue.destination as! Upcoming_race
            secondViewController.fromwhere = "Upcoming_event"            
        }
    }
    
    @IBAction func unwindToUpEventList(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
