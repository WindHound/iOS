//
//  Upcoming_race.swift
//  gpsTracker
//
//  Created by 신종훈 on 13/02/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit

class Upcoming_race: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var upcoming_race_list : [String] = []
    
    var fromwhere : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        upcoming_race_list.append("Race1")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItems = [add, search]
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(upcoming_race_list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = upcoming_race_list[indexPath.row]
        
        return(cell)
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
