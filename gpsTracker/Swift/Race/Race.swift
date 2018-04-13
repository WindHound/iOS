//
//  Race.swift
//  gpsTracker
//
//  Created by 신종훈 on 19/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit


private var upcoming_race : [Races] = []
private var tenupcoming_race : [String] = []
private var history_race : [Races] = []
private var tenhistory_race : [String] = []

private var Up = RaceUpcoming()

private var His = RaceHistory()

class Race: UITableViewController , UpcomingDelegate, HistoryDelegate {
    
    @IBOutlet var outside_table: UITableView!
    @IBOutlet weak var upcoming_table: UITableView!
    @IBOutlet weak var history_table: UITableView!
    
    private var UpcomingCellExpanded : Bool = true
    private var HistoryCellExpanded : Bool = false
    
    var allURL : String = "structure/race/all"
   
    var specificURL : String = "structure/race/get/"
    
    var All_Races : [Int] = []
    
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
                        self.All_Races = ids
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
//            upcoming_race.append("Race\(i)")
//            history_race.append("Race\(i)")
//        }
//
//        for i in 11...20 {
//            tenupcoming_race.append("Race\(i)")
//            tenhistory_race.append("Race\(i)")
//        }
        
        Up.delegate = self
        His.delegate = self
        
        upcoming_table.delegate = Up
        upcoming_table.dataSource = Up
        history_table.delegate = His
        history_table.dataSource = His

        // Do any additional setup after loading the view.
    }
    
    func updatearray() {
        let currentDate = Date()
        
        for i in 0...(All_Races.count - 1) {
            let jsonUrlString = URL(string: "\(baseURL)\(specificURL)\(All_Races[i])")
            
            let session = URLSession.shared
            session.dataTask(with: (jsonUrlString)!, completionHandler: {(data, response, error) -> Void in
                guard let data = data else {return}
                
                do {
                    
                    let race = try JSONDecoder().decode(Races.self, from: data)
                    
                    print(race)
                    
                    let serverEndDate = race.endDate
                    
//                    let endDate = Date(timeIntervalSince1970: TimeInterval(serverEndDate/1000))
                    let endDate = Date(timeIntervalSince1970: TimeInterval(1614718600000/1000)) // This need to be deleted
                    
                    if endDate < currentDate {
                        history_race.append(race)
                    } else {
                        upcoming_race.append(race)
                    }
                    
                    if history_race.count > 1 {
                        history_race.sort(by: {$1.startDate > $0.startDate})
                    }
                    
                    if upcoming_race.count > 1 {
                        upcoming_race.sort(by: {$0.startDate < $1.startDate})
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
        performSegue(withIdentifier: "Up To Info", sender: self)
    }
    
    internal func HistTo(datesource: Any, index: Int) {
        raceIndex = index
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
                let race = upcoming_race[raceIndex]
                secondViewController.UpOrHis = "Upcoming"
                secondViewController.raceID = race.id
                secondViewController.boatID = race.subordinates
                secondViewController.name = race.name
                secondViewController.startDate = race.startDate
                secondViewController.endDate = race.endDate
            } else {
                let race = history_race[raceIndex]
                secondViewController.UpOrHis = "History"
                secondViewController.raceID = race.id
                secondViewController.boatID = race.subordinates
                secondViewController.name = race.name
                secondViewController.startDate = race.startDate
                secondViewController.endDate = race.endDate
            }
        }
        
        if destination == "To Add Race" {
            let secondViewController = segue.destination as! Add_Race
            
            secondViewController.fromwhere = "Race"
            
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
        
        let race = upcoming_race[indexPath.row]
        
        cell.textLabel?.text = race.name
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == upcoming_race.count {
//            for i in 0...9 {
//                upcoming_race.append(tenupcoming_race[i])
//            }
//            tableView.reloadData()
//        }
//    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.UpTo(datasource: self, index: indexPath.row)
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
        
        let race = history_race[indexPath.row]
        
        cell.textLabel?.text = race.name
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == history_race.count {
//            for i in 0...9 {
//                history_race.append(tenhistory_race[i])
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
