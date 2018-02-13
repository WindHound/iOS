//
//  History_race.swift
//  gpsTracker
//
//  Created by 신종훈 on 13/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class History_race: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var history_race_list : [String] = []

    var fromwhere : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        
        history_race_list.append("Race1")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(history_race_list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = history_race_list[indexPath.row]
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "History_race_info", sender: self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextscreen = segue.identifier
        
        if (nextscreen == "History_race_info") {
            let secondViewController = segue.destination as! event_information
            secondViewController.fromwhere = "History_race"
        }
    }
    
    @IBAction func unwindToHistRaceList(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
