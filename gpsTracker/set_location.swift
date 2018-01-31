//
//  set_location.swift
//  gpsTracker
//
//  Created by 신종훈 on 30/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit
import MapKit

class set_location: UIViewController{

    @IBOutlet weak var myMap: MKMapView!
    
    let locationManager = CLLocationManager()

    var resultSearchController : UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let coordinate = locationManager.location?.coordinate
        
        // zoom into current position when map is first loaded
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(coordinate!, span)
        myMap.setRegion(region, animated: false)
        
        
        // Setting up table to store the results of location search and display it on screen
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // Setting up search bar and embedding it within the navigation bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Navigation bar is still visible when search results are displayed
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        
        // Overlay a semi-transparent background when the search bar is selected
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        // Limits the overlap area to just the View Controller's frame instead of the whole Navigation Controller
        definesPresentationContext = true
        
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension set_location : CLLocationManagerDelegate {
    // If authorization changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // If accessing GPS location is denied
        if (status == CLAuthorizationStatus.denied) {
            // Show alert message and acquire gps permission
            showLocationDisabledPopup()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            myMap.setRegion(region, animated: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    
    func showLocationDisabledPopup() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "GPS access is required to get current location", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) {(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
