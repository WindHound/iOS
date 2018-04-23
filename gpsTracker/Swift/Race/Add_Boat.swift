//
//  Add_Boat.swift
//  WindHound
//
//  Created by 신종훈 on 10/03/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

struct Boats_Post : Encodable, Decodable {
    var id : Int?
    var name : String
    var admins : [Int]
    var competitors : [Int]
    var races : [Int]
}

class Add_Boat: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var Added_Boats : [Boats_Post] = []

    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Boats: UITableView!
    
    var ids : [Int?] = []
    
    var boats : [Int] = []
    
    var requestURL : String = "structure/boat/add"

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
        boats = []
        
        if Added_Boats.count != 0 {
            for i in 0...Added_Boats.count - 1 {
                ids.append(nil)
                guard let jsonData = try? JSONEncoder().encode(Added_Boats[i]) else {return}
                guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) else {return}
                
                print(json)
                add(index: i, jsonData: jsonData)
            }
        }
        
        for i in 0...Added_Boats.count - 1{
            while(ids[i] == nil) {}
        }
        
        performSegue(withIdentifier: "Back To Add Race", sender: self)
    }
    
    func add(index: Int, jsonData: Data) {
        guard let url = URL(string: "\(baseURL)\(requestURL)") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    self.Added_Boats[index].id = json as? Int
                    self.ids[index] = json as? Int
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        }.resume()
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.identifier
        
        if destination == "Back To Add Race" {
            let secondViweController = segue.destination as! Add_Race
            secondViweController.Selected_Boats = self.Added_Boats
            secondViweController.textRace.text = String(self.Added_Boats.count)
        }
    }

    @IBAction func Add_Pressed(_ sender: Any) {
        if Name.text == "" {
            createAlert(title: "Invalid Name", message: "Empty Boat Name. Please enter the boat name", name: "Name")
        } else {
            var boatToAdd = Boats_Post(id: nil, name: "", admins: [], competitors: [], races: [])
            boatToAdd.name = Name.text!
            Added_Boats.append(boatToAdd)
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
        
        let boat = Added_Boats[indexPath.row]
        
        cell.textLabel?.text = boat.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            Added_Boats.remove(at: indexPath.row)
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
