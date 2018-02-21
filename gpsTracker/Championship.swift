//
//  event_list.swift
//  gpsTracker
//
//  Created by David Shin on 24/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit
import Foundation

var upcoming_champ : [String] = []
var tenupcoming_champ : [String] = []
var history_champ : [String] = []
var tenhistory_champ : [String] = []

class Championship: UITableViewController{
    
    
    @IBOutlet weak var outside_table: UITableView!
    @IBOutlet weak var upcoming_table: UITableView!
    @IBOutlet weak var history_table: UITableView!
    
    private var UpcomingCellExpanded : Bool = true
    
    private var HistoryCellExpanded : Bool = false

    var Up = Upcoming()

    var His = History()
    
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
        
        if tableView == outside_table {
            return(2)
        }
        if tableView == upcoming_table {
            return upcoming_champ.count
        }
        if tableView == history_table {
            return history_champ.count
        }
        return 0
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        UITableViewCell cell = nil
//
//        if tableView == Upcoming_table {
//            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Upcoming_champ")
//            cell.textLabel?.text = upcoming_champ[indexPath.row]
//        }
//        if tableView == History_table {
//            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "History_champ")
//            cell.textLabel?.text = history_champ[indexPath.row]
//        }
//
//        return cell
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To_Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Championship"
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

class Upcoming : NSObject, UITableViewDelegate, UITableViewDataSource {
    
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
    
}

class History : NSObject, UITableViewDataSource, UITableViewDelegate {
    
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
    
}
