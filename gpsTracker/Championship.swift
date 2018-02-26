//
//  event_list.swift
//  gpsTracker
//
//  Created by David Shin on 24/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit
import Foundation

private var upcoming_champ : [String] = []
private var tenupcoming_champ : [String] = []
private var history_champ : [String] = []
private var tenhistory_champ : [String] = []

protocol UpcomingDelegate: class {
    func UpTo(datasource: Any)
}

protocol HistoryDelegate: class {
    func HistTo(datesource: Any)
}

private var Up = Upcoming()

private var His = History()

class Championship: UITableViewController, UpcomingDelegate, HistoryDelegate{
    
    
    @IBOutlet weak var outside_table: UITableView!
    @IBOutlet weak var upcoming_table: UITableView!
    @IBOutlet weak var history_table: UITableView!
    
    private var UpcomingCellExpanded : Bool = true
    
    private var HistoryCellExpanded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...10 {
            upcoming_champ.append("Championship\(i)")
            history_champ.append("Championship\(i)")
        }
        
        for i in 11...20 {
            tenupcoming_champ.append("Championship\(i)")
            tenhistory_champ.append("Championship\(i)")
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To_Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Championship"
        }
        
        if destination == "Up_To_Event" || destination == "Hist_To_Event" {
            let secondViewController = segue.destination as! Event_list
            
            if destination == "Up_To_Event" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == outside_table {
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
            
            outside_table.beginUpdates()
            outside_table.endUpdates()

            outside_table.deselectRow(at: indexPath, animated: true)
        }
    
    }
    
    internal func UpTo(datasource: Any) {
        performSegue(withIdentifier: "Up_To_Event", sender: self)
    }
    
    internal func HistTo(datesource: Any) {
        performSegue(withIdentifier: "Hist_To_Event", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == outside_table {
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
        }
        return 50
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToChampList(segue:UIStoryboardSegue) { }
    
    
    

}

class Upcoming : UIView, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : UpcomingDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcoming_champ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Upcoming_champ", for: indexPath)
        
        cell.textLabel?.text = upcoming_champ[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == upcoming_champ.count {
            for i in 0...9 {
                upcoming_champ.append(tenupcoming_champ[i])
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.UpTo(datasource: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

class History : UIView, UITableViewDataSource, UITableViewDelegate {
    
    var delegate : HistoryDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history_champ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "History_champ", for: indexPath)
        
        cell.textLabel?.text = history_champ[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == history_champ.count {
            for i in 0...9 {
                history_champ.append(tenhistory_champ[i])
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.HistTo(datesource: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
