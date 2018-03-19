//
//  Race_list.swift
//  WindHound
//
//  Created by 신종훈 on 24/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Race_list: UITableViewController {
    
    var detailed_races : [Races] = []
    
    var UpOrHis : String = ""
    
    var raceID : [Int] = []
        
    var specificURL : String = "structure/race/get/"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Race"
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let profile = UIBarButtonItem(image: #imageLiteral(resourceName: "Profile_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(profile_tapped))
        
        self.navigationItem.rightBarButtonItems = [profile, add, search]
        updatearray()
        
    }
    
    func updatearray() {
        for i in 0...(raceID.count - 1) {
            let jsonUrlString = URL(string: "\(baseURL)\(specificURL)\(raceID[i])")
            
            let session = URLSession.shared
            session.dataTask(with: (jsonUrlString!), completionHandler: { (data, response, error) -> Void in
                guard let data = data else {return}
                
                do {
                    let race = try JSONDecoder().decode(Races.self, from: data)
                    
                    print(race)
                    
                    self.detailed_races.append(race)
                    if self.UpOrHis == "History" {
                        self.detailed_races.sort(by: {$1.startDate > $0.startDate})
                    }
                    
                    if self.UpOrHis == "Upcoming" {
                        self.detailed_races.sort(by: {$0.startDate < $1.startDate})
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
    
    @objc func profile_tapped() {
        performSegue(withIdentifier: "To_Profile", sender: self)
    }

    // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "To_Profile" {
            let secondViewController = segue.destination as! Profile_page
            secondViewController.fromwhere = "Detailed_Race"
        }
        
        if destination == "Race_info" {
            let secondViewController = segue.destination as! event_information
            secondViewController.fromwhere = "Race_List"
            secondViewController.UpOrHis = self.UpOrHis
        }
    }
    
    @IBAction func unwindToDetailedRace(segue:UIStoryboardSegue) { }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailed_races.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detailed_Race", for: indexPath)
        
        let race = detailed_races[indexPath.row]
        
        cell.textLabel?.text = race.name
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
