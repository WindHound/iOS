//
//  Existing_Races.swift
//  WindHound
//
//  Created by 신종훈 on 04/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Existing_Races: UITableViewController {
    private var Races : NSMutableArray = []
    
    private var Selected_Races : NSMutableArray = []
    
    var Already_added : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Existing Races"
        
        let add = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(add_button))
        
        self.navigationItem.rightBarButtonItems = [add]
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        for i in 1...10 {
            Races.add("Races\(i)")
        }
        
        if Already_added.count != 0 {
            for i in 0...(Already_added.count - 1) {
                Races.remove(Already_added.object(at: i))
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func add_button() {
        performSegue(withIdentifier: "Back To Add Event", sender: self)
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
        return Races.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Races", for: indexPath)
    
        cell.textLabel?.text = Races.object(at: indexPath.row) as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            // Remove checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            Selected_Races.remove(Races[indexPath.row])
            
            print(Selected_Races)
            
            if (Selected_Races.count == 0) {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            // Checkmark
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            Selected_Races.add(Races[indexPath.row])
            
            print(Selected_Races)
            
            
            if navigationItem.rightBarButtonItem?.isEnabled == false {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "Back To Add Event" {
            let secondViewController = segue.destination as! Add_Event
            secondViewController.races.addObjects(from: self.Selected_Races as! [Any])
            secondViewController.Selected_Races.reloadData()
        }
    }

}
