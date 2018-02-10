//
//  event_list.swift
//  gpsTracker
//
//  Created by 신종훈 on 24/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class event_list_admin: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var toolbar: UIToolbar!
    
    var eventlisttitle : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolbar.clipsToBounds = true
        
        eventlisttitle.append("Bristol")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(eventlisttitle.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = eventlisttitle[indexPath.row]
        
        return(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Upcoming_detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! event_information
        
        secondViewController.fromwhere = "Upcoming"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToEventList(segue:UIStoryboardSegue) { }
    
    
    

}
