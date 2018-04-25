import UIKit
import MapKit

class RaceDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    //Map
        @IBOutlet weak var mapView: MKMapView!
        
        //Starting Position - DEMO - SHOULD BE FIRST GPS LOCATION
        let initialLocation = CLLocation(latitude: 51.455896, longitude: -2.603118)
        
        //Radius of Map in meters
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        
        
        //Location Permission -- Also in .plist
        let locationManager = CLLocationManager()
        func checkLocationAuthorizationStatus() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                mapView.showsUserLocation = true
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            checkLocationAuthorizationStatus()
        }
        
        
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
            //Initialise map
            centerMapOnLocation(location: initialLocation)
            configureView()

            
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        //LeaderboardImageArray
        var LeaderboardImageArray = [UIImage(named: "sailboat-1"), UIImage(named: "sailboat-2"), UIImage(named: "sailboat-3"), UIImage(named: "sailboat-4"), UIImage(named: "sailboat-5"), UIImage(named: "sailboat-6")]
        
        //DataImageArray -- NOT USED
        var DataImageArray = [UIImage(named: "sailboat-1"), UIImage(named: "sailboat-2"), UIImage(named: "sailboat-3"), UIImage(named: "sailboat-4"), UIImage(named: "sailboat-5"), UIImage(named: "sailboat-6")]
        
        //Leaderboard
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            return LeaderboardImageArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardCollectionViewCell", for: indexPath)
                as! LeaderboardCollectionViewCell
            
            cell.LeaderboardImage.image = LeaderboardImageArray[indexPath.row]
            
            return cell
}
    
    //Race Replay
    
    var race: Race!

    
    private func configureView()
    {
        //
    }
    
    
    
    
    
}
