//
//  Existing_events.swift
//  WindHound
//
//  Created by 신종훈 on 27/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Existing_events: UITableViewController {
    
    @IBOutlet var Existing_Table: UITableView!
    
    private var Upcoming_Events : [Events] = []
    
    private var Selected_Events : [Events] = []
    
    var Already_added : [Events] = []
    
    var fromwhere : String = ""
    
    var allURL : String = "structure/event/all"
    
    var specificURL : String = "structure/event/get/"
    
    var All_Event : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Existing events"
        
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(add_button))
        
        self.navigationItem.rightBarButtonItems = [add]
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
        let jsonUrlString = URL(string: "\(baseURL)\(allURL)")
        
        let session = URLSession.shared
        
        session.dataTask(with: jsonUrlString!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    let ids = json as! [Int]
                    
                    if ids.count != 0 {
                        self.All_Event = ids
                        self.updatearray()
                    }
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        }.resume()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                    
//                    print(event)
                    
                    let serverenddate = event.endDate
                    
                    let enddate = Date(timeIntervalSince1970: TimeInterval(serverenddate/1000))
                    
                    if enddate >= currentDate {
                        var iscontain = false
                        if self.Already_added.count != 0 {
                            for i in 0...self.Already_added.count - 1 {
                                if self.Already_added[i].id == event.id {
                                    iscontain = true
                                    break
                                }
                            }
                        }
                        if !iscontain {
                            self.Upcoming_Events.append(event)
                            print(self.Upcoming_Events)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.Existing_Table.reloadData()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Upcoming_Events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Events", for: indexPath)
    
        cell.textLabel?.text = Upcoming_Events[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            // Remove checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            for i in 0...Selected_Events.count - 1 {
                if Selected_Events[i].id == Upcoming_Events[indexPath.row].id {
                    Selected_Events.remove(at: i)
                    break
                }
            }
            
            print(Selected_Events)
           
            if (Selected_Events.count == 0) {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            // Checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            Selected_Events.append(Upcoming_Events[indexPath.row])
            
            print(Selected_Events)

            
            if navigationItem.rightBarButtonItem?.isEnabled == false {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
        }
    }
    
    @IBAction func add_button() {
        if fromwhere == "Add Championship" {
            performSegue(withIdentifier: "Back To Add Champ", sender: self)
        }
        if fromwhere == "Add Race" {
            performSegue(withIdentifier: "Back To Add Race", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "Back To Add Champ" {
            let secondViewController = segue.destination as! Add_Championship
            secondViewController.Selected_Events = self.Selected_Events
            secondViewController.Save_button.isEnabled = true
            secondViewController.Selected_Events_Table.reloadData()
        }
        
        if destination == "Back To Add Race" {
            let secondViewController = segue.destination as! Add_Race
            secondViewController.Selected_Events = self.Selected_Events
            secondViewController.add_button.isEnabled = true
            secondViewController.Selected_Events_Table.reloadData()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
