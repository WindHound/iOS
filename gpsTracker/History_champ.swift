//
//  History_event.swift
//  gpsTracker
//
//  Created by 신종훈 on 10/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class History_champ: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var toolbar: UIToolbar!
    var event_history : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        event_history.append("London")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(event_history.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = event_history[indexPath.row]
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "History_event", sender: self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextscreen = segue.identifier
        
        if (nextscreen == "History_event") {
            let secondViewController = segue.destination as! History_event
            secondViewController.fromwhere = "History_champ"
        }
    }
    
    
    @IBAction func unwindToHistChampList(segue:UIStoryboardSegue) { }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
