//
//  Race.swift
//  gpsTracker
//
//  Created by 신종훈 on 19/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

private var upcoming_race : [String] = []
private var tenupcoming_race : [String] = []
private var history_race : [String] = []
private var tenhistory_race : [String] = []

private var Up = RaceUpcoming()

private var His = RaceHistory()

class Race: UITableViewController , UpcomingDelegate, HistoryDelegate {
    
    @IBOutlet var outside_table: UITableView!
    @IBOutlet weak var upcoming_table: UITableView!
    @IBOutlet weak var history_table: UITableView!
    
    private var UpcomingCellExpanded : Bool = true
    private var HistoryCellExpanded : Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        for i in 1...10 {
            upcoming_race.append("Race\(i)")
            history_race.append("Race\(i)")
        }
        
        for i in 11...20 {
            tenupcoming_race.append("Race\(i)")
            tenhistory_race.append("Race\(i)")
        }
        
        Up.delegate = self
        His.delegate = self
        
        upcoming_table.delegate = Up
        upcoming_table.dataSource = Up
        history_table.delegate = His
        history_table.dataSource = His

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if !UpcomingCellExpanded {
                UpcomingCellExpanded = true
                HistoryCellExpanded = false
            }
        }
        
        if indexPath.row == 1 {
            if !HistoryCellExpanded {
                UpcomingCellExpanded = false
                HistoryCellExpanded = true
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if UpcomingCellExpanded {
                return (self.outside_table.bounds.height - self.navigationController!.navigationBar.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)!)
            } else {
                return 50
            }
        }
        
        if indexPath.row == 1 {
            if HistoryCellExpanded {
                return (self.outside_table.bounds.height - self.navigationController!.navigationBar.frame.size.height - (self.tabBarController?.tabBar.frame.size.height)!)
            } else {
                return 50
            }
        }
        
        return 50
    }
    
    internal func UpTo(datasource: Any) {
        performSegue(withIdentifier: "Up To Info", sender: self)
    }
    
    internal func HistTo(datesource: Any) {
        performSegue(withIdentifier: "Hist To Info", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To_Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Race"
        }
        
        if destination == "Up To Info" || destination == "Hist To Info" {
            let secondViewController = segue.destination as! event_information
            secondViewController.fromwhere = "Race"
            if destination == "Up To Info" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
    }
    
    @IBAction func unwindToRaceList(segue:UIStoryboardSegue) { }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

private class RaceUpcoming : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : UpcomingDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcoming_race.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Upcoming_race", for: indexPath)
        
        cell.textLabel?.text = upcoming_race[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == upcoming_race.count {
            for i in 0...9 {
                upcoming_race.append(tenupcoming_race[i])
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.UpTo(datasource: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private class RaceHistory : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var delegate : HistoryDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history_race.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "History_race", for: indexPath)
        
        cell.textLabel?.text = history_race[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == history_race.count {
            for i in 0...9 {
                history_race.append(tenhistory_race[i])
            }
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.HistTo(datesource: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
