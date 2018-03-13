import UIKit
import MapKit

class RaceDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

    @IBOutlet weak var distanceLabel: UILabel!
//  @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    //Map
        @IBOutlet weak var mapView: MKMapView!
 /*
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
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
            {
                mapView.showsUserLocation = true
            } else
            {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        override func viewDidAppear(_ animated: Bool)
        {
            super.viewDidAppear(animated)
            checkLocationAuthorizationStatus()
        }
        
 */
        override func viewDidLoad()
        {
            super.viewDidLoad()
            //Initialise map
          //  centerMapOnLocation(location: initialLocation)
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
        let distance = Measurement(value: race.distance, unit: UnitLength.meters)
        let seconds = Int(race.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(race.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedSpeed = FormatDisplay.speed(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.nauticalMiles)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        dateLabel.text = formattedDate
        timeLabel.text = "Time:  \(formattedTime)"
        speedLabel.text = "Speed:  \(formattedSpeed)"
        
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = race.locations,
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline
    {
        guard let locations = race.locations else
        {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map
            { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func loadMap()
    {
        guard
            let locations = race.locations,
            locations.count > 0,
            let region = mapRegion()
            else
            {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this race has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
            }
        
        mapView.setRegion(region, animated: true)
        mapView.add(polyLine())
    }
    
}

extension RaceDetailsViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        guard let polyline = overlay as? MKPolyline else
        {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
    }
}
