//
//  event_list.swift
//  gpsTracker
//
//  Created by 신종훈 on 24/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class upcoming_champ: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var upcoming_champ_list : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upcoming_champ_list.append("Bristol")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(upcoming_champ_list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = upcoming_champ_list[indexPath.row]
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Upcoming_event_detail", sender: self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextscreen = segue.identifier
        
        if (nextscreen == "Upcoming_event_detail") {
            let secondViewController = segue.destination as! Upcoming_events
            secondViewController.fromwhere = "Upcoming_Champ"
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
    
    @IBAction func unwindToUpChampList(segue:UIStoryboardSegue) { }
    
    
    

}
