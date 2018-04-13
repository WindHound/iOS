//
//  Race_Master.swift
//  WindHound
//
//  Created by 신종훈 on 12/04/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

struct Races : Decodable {
    let id : Int
    let name : String
    let subordinates : [Int] // Boat
    let managers : [Int] // Race
    let admins : [Int]
    let startDate : Int
    let endDate : Int
}

private var upcoming_race = [Races]()
private var history_race = [Races]()
private var display_race = [Races]()

class Race_Master: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Race_Table: UITableView!
    
    var isUpcoming : Bool = true
    
    var allURL : String = "structure/race/all"
    
    var specificURL : String = "structure/race/get/"
    
    var All_Races : [Int] = []
    
    var raceIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    
                    if (self.isUpcoming) {
                        display_race = upcoming_race
                    } else {
                        display_race = history_race
                    }
                    
                    DispatchQueue.main.async {
                        self.Race_Table.reloadData()
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
    
    @IBAction func segmentTableViewSwitch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isUpcoming = true
            display_race = upcoming_race
            break
        
        case 1:
            isUpcoming = false
            display_race = history_race
            break
        default:
            break
        }
        
        Race_Table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display_race.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Races", for: indexPath)
        
        let event =  display_race[indexPath.row]
        
        cell.textLabel?.text = event.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        raceIndex = indexPath.row
        if isUpcoming {
            performSegue(withIdentifier: "Up To Info", sender: self)
        } else {
            performSegue(withIdentifier: "Hist To Info", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Race"
        }
        
        if destination == "Up To Info" || destination == "Hist To Info" {
            let secondViewController = segue.destination as! event_information
            secondViewController.fromwhere = "Race"
            let race = display_race[raceIndex]
            secondViewController.raceID = race.id
            secondViewController.boatID = race.subordinates
            secondViewController.name = race.name
            secondViewController.startDate = race.startDate
            secondViewController.endDate = race.endDate
            if destination == "Up To Info" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
        
        if destination == "To Add Race" {
            let secondViewController = segue.destination as! Add_Race
            
            secondViewController.fromwhere = "Race"
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
