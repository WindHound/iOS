//
//  event_list.swift
//  gpsTracker
//
//  Created by David Shin on 24/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit
import Foundation

struct Championships : Decodable {
    let admins : [Int]
    let endDate : Int
    let id : Int
    let managers : [Int] // null
    let name : String
    let startDate : Int
    let subordinates : [Int] // Event
}

private var upcoming_champ = [Championships]()
private var tenupcoming_champ : [String] = []
private var history_champ = [Championships]()
private var tenhistory_champ : [String] = []


protocol UpcomingDelegate: class {
    func UpTo(datasource: Any, index: Int)
}

protocol HistoryDelegate: class {
    func HistTo(datesource: Any, index: Int)
}

private var Up = Upcoming()

private var His = History()

class Championship: UITableViewController, UpcomingDelegate, HistoryDelegate{
    
    
    @IBOutlet weak var outside_table: UITableView!
    @IBOutlet weak var upcoming_table: UITableView!
    @IBOutlet weak var history_table: UITableView!
    
    private var UpcomingCellExpanded : Bool = true
    
    private var HistoryCellExpanded : Bool = false
    
    var All_Championship : [Int] = []
        
    var allURL : String = "structure/championship/all/"
    
    var specificURL : String = "structure/championship/get/"
    
    var eventIndex : Int = 0
    
//    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activityIndicator.center = self.view.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        view.addSubview(activityIndicator)
        
        let jsonUrlString = URL(string: "\(baseURL)\(allURL)")
        
        let session = URLSession.shared
//        activityIndicator.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
        session.dataTask(with: jsonUrlString!) { (data, response, error) in
            if let data = data {
                do {

                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    let ids = json as! [Int]
                    
                    if ids.count != 0 {
                        self.All_Championship = ids
                        self.updatearray()
                        
                    }
                    
                    //                    print("\(upcoming_champ.count) after update function")
                } catch {
                    print("ERROR")
                }
            }
            if let error = error {
                print(error)
            }
            
            }.resume()
//        activityIndicator.stopAnimating()
//        UIApplication.shared.endIgnoringInteractionEvents()
        Up.delegate = self
        His.delegate = self
        
        upcoming_table.delegate = Up
        upcoming_table.dataSource = Up
        history_table.delegate = His
        history_table.dataSource = His
        
        
//        for i in 1...10 {
//            upcoming_champ.append("Championship\(i)")
//            history_champ.append("Championship\(i)")
//        }
//
//        for i in 11...20 {
//            tenupcoming_champ.append("Championship\(i)")
//            tenhistory_champ.append("Championship\(i)")
//        }

        // Do any additional setup after loading the view.
    }
    
    func updatearray() {
        
        let currentDate = Date()
        
        for i in 0...(All_Championship.count - 1) {
            let jsonUrlString = URL(string: "\(baseURL)\(specificURL)\(All_Championship[i])")
            
            let session = URLSession.shared
            
            session.dataTask(with: (jsonUrlString!), completionHandler: { (data, response, error) -> Void in
                guard let data = data else {return}
                
                do {
                    
                    let championship = try JSONDecoder().decode(Championships.self, from: data)
                    print(championship)
                    
                    let serverenddate = championship.endDate
                    
                    let enddate = Date(timeIntervalSince1970: TimeInterval(serverenddate/1000))
                    
                    if enddate < currentDate {
                        history_champ.append(championship)
                    } else {
                        upcoming_champ.append(championship)
                    }
                    
                    if history_champ.count > 1 {
                        history_champ.sort(by: {$1.startDate > $0.startDate})
                    }
                    
                    if upcoming_champ.count > 1 {
                        upcoming_champ.sort(by: {$0.startDate < $1.startDate})
                    }
                    
                    DispatchQueue.main.async { // Correct
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To_Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Championship"
        }
        
        if destination == "Up_To_Event" || destination == "Hist_To_Event" {
            let secondViewController = segue.destination as! Event_list
            
            if destination == "Up_To_Event" {
                let event = upcoming_champ[eventIndex]
                secondViewController.eventID = event.subordinates
                secondViewController.UpOrHis = "Upcoming"
            } else {
                let event = history_champ[eventIndex]
                secondViewController.eventID = event.subordinates
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
    
    internal func UpTo(datasource: Any, index: Int) {
        eventIndex = index
        performSegue(withIdentifier: "Up_To_Event", sender: self)
    }
    
    internal func HistTo(datesource: Any, index: Int) {
        eventIndex = index
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

class Upcoming : UITableViewController {
    
    var delegate : UpcomingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcoming_champ.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Upcoming_champ", for: indexPath)
        
        let championship = upcoming_champ[indexPath.row]
        
        
        cell.textLabel?.text = championship.name
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
////        if indexPath.row + 1 == upcoming_champ.count {
////            for i in 0...9 {
////                upcoming_champ.append(tenupcoming_champ[i])
////            }
////            tableView.reloadData()
////        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.UpTo(datasource: self, index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

class History : UITableViewController{
    
    var delegate : HistoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history_champ.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "History_champ", for: indexPath)
        
        let championship = history_champ[indexPath.row]

        cell.textLabel?.text = (championship).name
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == history_champ.count {
//            for i in 0...9 {
//                history_champ.append(tenhistory_champ[i])
//            }
//            tableView.reloadData()
//        }
//    }
//
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.HistTo(datesource: self, index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
