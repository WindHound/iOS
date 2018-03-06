//
//  Existing_Races.swift
//  WindHound
//
//  Created by 신종훈 on 06/03/2018.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "Back To Add Event" {
            let secondViewController = segue.destination as! Add_Event
            secondViewController.Selected_Races.addObjects(from: self.Selected_Races as! [Any])
            secondViewController.Selected_Races_Table.reloadData()
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
