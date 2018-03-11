//
//  Add_Boat.swift
//  WindHound
//
//  Created by 신종훈 on 10/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Add_Boat: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var Added_Boats : NSMutableArray = []

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Boats: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Add Boat"
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done_pressed))
        self.navigationItem.rightBarButtonItems = [done]

        // Do any additional setup after loading the view.
    }
    
    @IBAction func done_pressed() {
        performSegue(withIdentifier: "Back To Add Race", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "Back To Add Race" {
            let secondViweController = segue.destination as! Add_Race
            secondViweController.Selected_Boats = self.Added_Boats
            secondViweController.textRace.text = "\(self.Added_Boats.count)"
        }
    }

    @IBAction func Add_Pressed(_ sender: Any) {
        if Name.text == "" {
            createAlert(title: "Invalid Name", message: "Empty Boat Name. Please enter the boat name", name: "Name")
        } else {
            Added_Boats.add(Name.text as Any)
            Boats.reloadData()
            Name.text = ""
        }
    }
    
    func createAlert(title:String, message:String, name: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) {
            (action) in if name == "Name" {
                self.Name.becomeFirstResponder()
            }
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Added_Boats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Boats", for: indexPath)
        
        cell.textLabel?.text = Added_Boats.object(at: indexPath.row) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            Added_Boats.removeObject(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
