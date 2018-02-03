//
//  set_location.swift
//  gpsTracker
//
//  Created by 신종훈 on 30/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit
import MapKit

// It acts like an interface
protocol HandleMapSearch {
    func dropPinZommIn(placemark:MKPlacemark)
}

class set_location: UIViewController, UISearchBarDelegate{

    
    let locationManager = CLLocationManager()

    var resultSearchController : UISearchController? = nil
    
    var selectedPin : MKPlacemark? = nil
    
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var add_button: UIBarButtonItem!
    
    @IBOutlet weak var search_button: UIBarButtonItem!
    
    var location = String()
    var latitude : Double!
    var longitude : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // zoom into current position when map is first loaded
        let coordinate = locationManager.location?.coordinate
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(coordinate!, span)
        myMap.setRegion(region, animated: false)
        myMap.showsUserLocation = true
        
        // Make back button color to white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        add_button.isEnabled = false
        

    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        // Setting up table to store the results of location search and display it on screen
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        locationSearchTable.handleMapSearchDelegate = self
        
        // Setting up search bar and embedding it within the navigation bar
        let searchBar = resultSearchController!.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search for places"
        
        
        // Navigation bar is still visible when search results are displayed
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        
        
        present(resultSearchController!, animated: true, completion: nil)

        
        // Overlay a semi-transparent background when the search bar is selected
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        // Limits the overlap area to just the View Controller's frame instead of the whole Navigation Controller
        definesPresentationContext = false
        
        // This passes along a handle of the myMap from the set)location view controller onto the locationSearchTable
        locationSearchTable.mapView = myMap
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let add_event = segue.destination as! Add_event
        add_event.textLocation.text = location
        add_event.latitude = latitude
        add_event.longitude = longitude
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

extension set_location: HandleMapSearch {
    func dropPinZommIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        myMap.removeAnnotations(myMap.annotations)
        
        // Create new pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        myMap.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        myMap.setRegion(region, animated: true)
        
        // Assinging latitude and longitude value to pass to add_event view controller
        location = placemark.name!
        latitude = placemark.coordinate.latitude
        longitude = placemark.coordinate.longitude
        
        // Enable add button
        add_button.isEnabled = true
        
    }
}
