//
//  Related_Boats.swift
//  WindHound
//
//  Created by 신종훈 on 10/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Related_Boats: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var toolbar: UIToolbar!
    
    var Boats : [Int] = []
    
    var Chosen_Boat : Int = 0
    
    var Cancel : Bool = false
    
    override func viewDidLoad() {
        
        toolbar.clipsToBounds = true

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel_Pressed(_ sender: Any) {
        performSegue(withIdentifier: "Back To Race Information", sender: self)
        Cancel = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Boats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Boats", for: indexPath)
        
        cell.textLabel?.text = String(Boats[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Chosen_Boat = Boats[indexPath.row]
        performSegue(withIdentifier: "Back To Race Information", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "Back To Race Information" {
            if !Cancel {
                let secondViewController = segue.destination as! event_information
                
                secondViewController.Chosen_Boat = self.Chosen_Boat
                
                if Chosen_Boat != 0 {
                    secondViewController.Boat.text = String(secondViewController.Chosen_Boat)
                }
            }
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
