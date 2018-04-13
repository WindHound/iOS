//
//  Championship_Master.swift
//  WindHound
//
//  Created by 신종훈 on 12/04/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

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
private var history_champ = [Championships]()
private var display_champ = [Championships]()



class Championship_Master: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var championships_table: UITableView!
    
    var isUpcoming : Bool = true
    
    var All_Championship : [Int] = []
    
    var allURL : String = "structure/championship/all"
    
    var specificURL : String = "structure/championship/get/"
    
    var eventIndex : Int = 0
    
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
                        self.All_Championship = ids
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
                    
                    if (self.isUpcoming) {
                        display_champ = upcoming_champ
                    } else {
                        display_champ = history_champ
                    }
                    
                    DispatchQueue.main.async { // Correct
                        self.championships_table.reloadData()
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
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            isUpcoming = true
            display_champ = upcoming_champ
            break
        
        case 1:
            isUpcoming = false
            display_champ = history_champ
            break
        default:
            break
        }
        championships_table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display_champ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Championships", for: indexPath)
        
        let championship = display_champ[indexPath.row]
        
        cell.textLabel?.text = championship.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventIndex = indexPath.row
        if isUpcoming {
            performSegue(withIdentifier: "Up To Event", sender: self)
        } else {
            performSegue(withIdentifier: "Hist To Event", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Championship"
        }
        
        if destination == "Up To Event" || destination == "Hist To Event" {
            let secondViewController = segue.destination as! Event_list
            let event = display_champ[eventIndex]
            secondViewController.eventID = event.subordinates

            if destination == "Up To Event" {
                secondViewController.UpOrHis = "Upcoming"
            } else {
                secondViewController.UpOrHis = "History"
            }
        }
        
        
    }
    
    @IBAction func unwindToChampList(segue:UIStoryboardSegue) { }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
