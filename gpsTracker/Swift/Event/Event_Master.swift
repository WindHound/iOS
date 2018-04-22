//
//  Events_Master.swift
//  Pods-gpsTracker
//
//  Created by 신종훈 on 12/04/2018.
//

import UIKit

struct Events : Encodable, Decodable {
    var id : Int?
    var name : String
    var startDate : Int // Race
    var endDate : Int // Championship
    var admins : [Int]
    var championships : [Int]
    var races : [Int]
}

class Event_Master: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Events_Table: UITableView!
    
    var isUpcoming : Bool = true
    
    var All_Event : [Int] = []
    
    var allURL : String = "structure/event/all"
    
    var specificURL : String = "structure/event/get/"
    
    var raceIndex : Int = 0
    
    var upcoming_event = [Events]()
    var history_event = [Events]()
    var display_event = [Events]()
    
    var isAdd : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = URL(string: "\(baseURL)\(allURL)")
        
        let longTitleLabel = UILabel()
        longTitleLabel.text = "WindHound"
        longTitleLabel.textColor = UIColor.white
        longTitleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: longTitleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let session = URLSession.shared
        //        activityIndicator.startAnimating()
        //        UIApplication.shared.beginIgnoringInteractionEvents()
        session.dataTask(with: jsonUrlString!) { (data, response, error) in
            if let data = data {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    print(json)
                    
                    let ids = json as! [Int]
                    
                    if ids.count != 0 {
                        self.All_Event = ids
                        self.updatearray()
                        
                    }
                    
                    //                    print("\(upcoming_champ.count) after update function")
                } catch {
                    print(error)
                }
            }
            if let error = error {
                print(error)
            }
            
            }.resume()
        
        // Do any additional setup after loading the view.
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
                        self.history_event.append(event)
                    } else {
                        self.upcoming_event.append(event)
                    }
                    
                    if self.history_event.count > 1 {
                       self.history_event.sort(by: {$1.startDate > $0.startDate})
                    }
                    
                    if self.upcoming_event.count > 1 {
                        self.upcoming_event.sort(by: {$0.startDate < $1.startDate})
                    }
                    
                    if (self.isUpcoming) {
                        self.display_event = self.upcoming_event
                    } else {
                        self.display_event = self.history_event
                    }
                    
                    DispatchQueue.main.async {
                        self.Events_Table.reloadData()
                    }
                    
                } catch {
                    print(error)
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
    
    @IBAction func segmentTableViewChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isUpcoming = true
            display_event = upcoming_event
            break
            
        case 1:
            isUpcoming = false
            display_event = history_event
            break
            
        default:
            break
        }
        
        Events_Table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display_event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Events", for: indexPath)
        
        let race = display_event[indexPath.row]
        
        cell.textLabel?.text = race.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        raceIndex = indexPath.row
        if isUpcoming {
            performSegue(withIdentifier: "Up To Race", sender: self)
        } else {
            performSegue(withIdentifier: "Hist To Race", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Event"
        }
        
        if destination == "Up To Race" || destination == "Hist To Race" {
            let secondViewController = segue.destination as! Race_list
            let race = display_event[raceIndex]
            secondViewController.raceID = race.races
            
            if destination == "Up To Event" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
        
        if destination == "To Add Event" {
            let secondViewController = segue.destination as! Add_Event
            
            if isAdd {
                secondViewController.toolBarName = "Add Event"
            } else {
                secondViewController.toolBarName = "Edit Event"
            }
        }
    }
    
    @IBAction func Add_Pressed(_ sender: Any) {
        isAdd = true
        performSegue(withIdentifier: "To Add Event", sender: self)
    }
    
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

