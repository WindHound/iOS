//
//  LocationSearchTable.swift
//  gpsTracker
//
//  Created by 신종훈 on 31/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    // Will be used to stash search results for easy access
    var matchingItems:[MKMapItem] = []
    // Search queries rely on a map region to priortise local results
    var mapView : MKMapView? = nil
    
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // guard statement unwraps the optional values for mapView and teh search bar text
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else {return}
        
        // A search request is comprised of a search string, and a map region that provides location context.
        // The search string comes from the search bar text, and the map region comes from the mapView
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        // performs the actual search on the request objecct.
        let search = MKLocalSearch(request: request)
        
        // Executes the search query and returns a MKLocalSearchResponse object which contains an array of mapItems.
        // You stach these mapitems inside matchingItems, and then reload the table
        search.start(completionHandler: {response, _ in
        guard let response = response else {return}
        self.matchingItems = response.mapItems
        self.tableView.reloadData()
        }
        )
        
        
    }
}

// data is coming back from the API, therefore below codes wire up those data to the UI
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // matchingItems array determines the number of table rows
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        // The cell's build-in textLabel is set to the placemark name of the Map Item
        let selectedItem = matchingItems[indexPath.row].placemark
        cell?.textLabel?.text = selectedItem.name
        
        // Used to fill the address
        cell?.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell!
    }
    
    
}

// This class extension groups UITableViewDelegate methods together
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZommIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
