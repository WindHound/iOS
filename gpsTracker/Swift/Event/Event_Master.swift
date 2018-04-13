//
//  Events_Master.swift
//  Pods-gpsTracker
//
//  Created by 신종훈 on 12/04/2018.
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
private var history_event = [Events]()
private var display_event = [Events]()

class Event_Master: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var Events_Table: UITableView!
    
    var isUpcoming : Bool = true
    
    var All_Event : [Int] = []
    
    var allURL : String = "structure/event/all"
    
    var specificURL : String = "structure/event/get/"
    
    var raceIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        self.All_Event = ids
                        self.updatearray()
                        
                    }
                    
                    //                    print("\(upcoming_champ.count) after update function")
                } catch {
                    print(error    )
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
                    
                    if (self.isUpcoming) {
                        display_event = upcoming_event
                    } else {
                        display_event = history_event
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
            secondViewController.raceID = race.subordinates
            
            if destination == "Up To Event" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
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

