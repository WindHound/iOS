//
//  History_event.swift
//  gpsTracker
//
//  Created by David Shin on 10/02/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

struct Events : Decodable {
    let admins : [Int]
    let id : Int
    let managers : [Int]
    let name : String
    let subordinates : [Int]
}

private var upcoming_event : [String] = []
private var tenupcoming_event : [String] = []
private var history_event : [String] = []
private var tenhistory_event : [String] = []


private var Up = EventUpcoming()

private var His = EventHistory()



class Event: UITableViewController, UpcomingDelegate, HistoryDelegate{

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var outside_table: UITableView!
    @IBOutlet weak var upcoming_table: UITableView!
    @IBOutlet weak var history_table: UITableView!
    
    private var UpcomingCellExpanded : Bool = true
    
    private var HistoryCellExpanded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        guard let jsonUrlString = URL(string: "http://192.168.137.1:8080/structure/event/all/") else {return}

        let session = URLSession.shared
        
        session.dataTask(with: jsonUrlString) { (data, response, error) in
            
//            guard let data = data else {return}
//
//            do {
//                let course = try JSONDecoder().decode(Events.self, from: data)
//
//                upcoming_event.add(course)
//
//                self.upcoming_table.reloadData()
//
//                print(upcoming_event.count)
//
//            } catch {
//                print("ERROR")
//            }
            
//            admins =     (
//                1
//            );
//            id = 0;
//            managers =     (
//                1,
//                2
//            );
//            name = "event_id0";
//            subordinates =     (
//                1
//            );
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let ids = json as! [Int]
                } catch {

                }
            }
            if let error = error {
                print(error)
                print("Error")
            }
            }.resume()
        
        for i in 1...10 {
            upcoming_event.append("Event\(i)")
            history_event.append("Event\(i)")
        }
        
        for i in 11...20 {
            tenupcoming_event.append("Event\(i)")
            tenhistory_event.append("Event\(i)")
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
        performSegue(withIdentifier: "Up_To_Race", sender: self)
    }
    
    internal func HistTo(datesource: Any) {
        performSegue(withIdentifier: "Hist_To_Race", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To_Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Event"
        }
        
        if destination == "Up_To_Race" || destination == "Hist_To_Race" {
            let secondViewController = segue.destination as! Race_list
            if destination == "Up_To_Race" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "History_event", sender: self)
//        tableView.reloadData()
//    }
    
    
    @IBAction func unwindToEventList(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class EventUpcoming : UIView, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : UpcomingDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcoming_event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Upcoming_event", for: indexPath)
        
//        let event = upcoming_event[indexPath.row] as! Events
        
//        print(event.name)
        
//        cell.textLabel?.text = event.name

        cell.textLabel?.text = upcoming_event[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == upcoming_event.count {
            for i in 0...9 {
                upcoming_event.append(tenupcoming_event[i])
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.UpTo(datasource: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class EventHistory : UIView, UITableViewDataSource, UITableViewDelegate {
    
    var delegate : HistoryDelegate?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history_event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "History_event", for: indexPath)
        
        cell.textLabel?.text = history_event[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == history_event.count {
            for i in 0...9 {
                history_event.append(tenhistory_event[i])
            }
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.HistTo(datesource: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
