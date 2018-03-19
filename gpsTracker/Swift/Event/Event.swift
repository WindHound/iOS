//
//  History_event.swift
//  gpsTracker
//
//  Created by David Shin on 10/02/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit

struct Events : Decodable {
    let id : Int
    let name : String
    let subordinates : [Int] // Race
    let managers : [Int] // Championship
    let admins : [Int]
    let startDate : Int
    let endDate : Int
}

private var upcoming_event = [Events]()
private var tenupcoming_event : [String] = []
private var history_event = [Events]()
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
        
    var allURL : String = "structure/event/all/"
    
    var specificURL : String = "structure/event/get/"

    var All_Event : [Int] = []
    
    var raceIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let jsonUrlString = URL(string: "\(baseURL)\(allURL)")
        
        let session = URLSession.shared
        session.dataTask(with: jsonUrlString!) { (data, response, error) in
            
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let ids = json as! [Int]
                    
                    if ids.count != 0 {
                        self.All_Event = ids
                        print(self.All_Event[0])
                        self.updatearray()
                    }
                } catch {
                    print("ERROR")
                }
            }
            if let error = error {
                print(error)
            }
            
        }.resume()
        
//        for i in 1...10 {
//            upcoming_event.append("Event\(i)")
//            history_event.append("Event\(i)")
//        }
//
//        for i in 11...20 {
//            tenupcoming_event.append("Event\(i)")
//            tenhistory_event.append("Event\(i)")
//        }
        
        Up.delegate = self
        His.delegate = self
        
        upcoming_table.delegate = Up
        upcoming_table.dataSource = Up
        history_table.delegate = His
        history_table.dataSource = His

    }
    
    func updatearray() {
        let currentDate = Date()
        
        for i in 0...(All_Event.count - 1) {
            let jsonUrlString = URL(string: "\(baseURL)\(specificURL)\(All_Event[i])")
            
            let session = URLSession.shared
            session.dataTask(with: (jsonUrlString!), completionHandler: {(data, response, error) -> Void in
                guard let data = data else {return}
                do {
                    
                    let event = try JSONDecoder().decode(Events.self, from: data)
                    
                    print(event)
                    
                    let serverenddate = event.endDate
                    
                    let enddate = Date(timeIntervalSince1970: TimeInterval(serverenddate/1000))
                    
                    if enddate < currentDate {
                        history_event.append(event)
                    } else {
                        upcoming_event.append(event)
                    }
                    
                    if history_event.count > 1 {
                        history_event.sort(by: {$1.startDate > $0.startDate})
                    }
                    
                    if upcoming_event.count > 1 {
                        upcoming_event.sort(by: {$0.startDate < $1.startDate})
                    }
                    
                    DispatchQueue.main.async {
                        self.upcoming_table.reloadData()
                        self.history_table.reloadData()
                    }
                    
                } catch {
                    print("ERROR")
                }
                
                if let error = error {
                    print(error)
                }
            }).resume()
        }
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
    
    
    
    internal func UpTo(datasource: Any, index: Int) {
        raceIndex = index
        performSegue(withIdentifier: "Up_To_Race", sender: self)
    }
    
    internal func HistTo(datesource: Any, index: Int) {
        raceIndex = index
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
                let race = upcoming_event[raceIndex]
                secondViewController.raceID = race.subordinates
                secondViewController.UpOrHis = "Upcoming"
            } else {
                let race = history_event[raceIndex]
                secondViewController.raceID = race.subordinates
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

        let event = upcoming_event[indexPath.row]
    
        cell.textLabel?.text = event.name
        
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == upcoming_event.count {
//            for i in 0...9 {
//                upcoming_event.append(tenupcoming_event[i])
//            }
//            tableView.reloadData()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.UpTo(datasource: self, index: indexPath.row)
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
        
        let event = history_event[indexPath.row]
        
        cell.textLabel?.text = event.name
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == history_event.count {
//            for i in 0...9 {
//                history_event.append(tenhistory_event[i])
//            }
//
//            tableView.reloadData()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.HistTo(datesource: self, index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
