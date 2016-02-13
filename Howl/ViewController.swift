//
//  ViewController.swift
//  Howl
//
//  Created by Kyle Willcox on 2/16/15.
//  Copyright (c) 2015 TimeLapse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    //Add new howl button. 
    //Segues to Howl View Controller
    weak var howlButton: UIButton!

    
    //The Map View
    @IBOutlet weak var MapView: MKMapView!

    //Variable for adding new howls
    var locationManager:CLLocationManager!
    var newHowlLat:Double!
    var newHowlLon:Double!
    var newHowlAnnotation:MKPointAnnotation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Declaring the delegate as self and will not show user location
        MapView.showsUserLocation = false
        MapView.delegate = self
        
        //Initialization of map, gesutre for adding point 
        //and lastly adds all the points read in from the webserver
        setUptheMap()
        loadThePoints()
        createTheLongTapGesture()
        
    
        //Don't allow user to segue to create new howl until point has been chosen
        howlButton.enabled = false
        
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func viewWillAppear(animated: Bool) {
        
        sleep(2)
        loadThePoints()
        println("executing")
        MapView.delegate = self
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        println("delegate called")
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation!
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
   


    
    //Segue to Howl View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "sendLocation") {
            var svc = segue.destinationViewController as! HowlViewController
            
            //Sending the variables of the point picked in viewcontroller
            svc.howlLAT = newHowlLat
            svc.howlLON = newHowlLon
        }
    }
    
    //Remove temporary annotation from MapView 
    
    @IBAction func howlButtonTouchUpInside(sender: AnyObject) {
        
        MapView.removeAnnotation(newHowlAnnotation)
    
    }
    
    
    //Function that takes in array of howls and adds them to mapview
    
    func addHowlsToTheMap(howlArray:[howlModel]){
        
        //Debugging
        //println("The # of howls \(howlArray.count)")

        
        var locationCL:CLLocationCoordinate2D
        
        //iterate through the howlmodels and add each one to map view
        for howls in howlArray {
            
            //println("######\(howls.description)######")
            
            var newHowl = CustomPointAnnotation()
        
            var latCL:CLLocationDegrees = howls.latitude
            var lonCL:CLLocationDegrees = howls.longetitude
            
            locationCL = CLLocationCoordinate2D(latitude: latCL,longitude: lonCL)
            
            newHowl.coordinate = locationCL
            newHowl.title = howls.title
            newHowl.subtitle = howls.desc
            newHowl.imageName = "smallPoint.png"
            
            MapView.addAnnotation(newHowl)
           
        }
        
        
        
    }
    
    
    
    //Read in the JSON data from webserver and append them to howlModel Array
    func loadThePoints(){
        
        //Intilize the empty array
        var currentHowl = [howlModel]()
        
        
        //Use data manager to successful retrieve JSON data
        DataManager.getLocationDataWithSuccess { (localData) -> Void in
            
            
            //JSON constants
            let json = JSON(data: localData)
            let jsonArray = json.arrayValue
            let count = jsonArray?.count
            
            
            var localID,latt,longetit,title,descrip,pt:JSON
            
            // An Instance of Howl Model
            var howlFromJSON:howlModel
            
            //Iterate through every entry in the JSON array
            for(var i = 0; i < count; i++){
                
                
                let localID = json[i]["local_id"]
                let latt = json[i]["latitude"]
                let longetit = json[i]["longitude"]
                let title = json[i]["title"]
                let descrip = json[i]["description"]
                pt = json[i]["post_time"]
                
                //Assign new howl model every iteration
                howlFromJSON = howlModel(l_id: localID.integerValue, lat: latt.doubleValue, longet: longetit.doubleValue, title: title.stringValue, desc: descrip.stringValue, post_time: pt.stringValue)
                
                //Add to array
                currentHowl.append(howlFromJSON)
                
                
                
                
            }//end json array for loop
            
            self.addHowlsToTheMap(currentHowl)
            
            
        }//end datamanager get locations
        
        //Add the howls to the map
        
        
    }//end load the points
    
    
    //
    func setUptheMap (){
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        let lat:CLLocationDegrees = 34.2111
        let longet:CLLocationDegrees = -77.7986
        let beach = CLLocationCoordinate2DMake(lat, longet)
        var span = MKCoordinateSpanMake(1.0,1.0)
        
        var area = MKCoordinateRegion(center: beach, span: span)
        
        
        
        MapView.setRegion(area, animated: true)
        
        self.MapView.mapType = MKMapType.Hybrid
        
        
    }
    
    func createTheLongTapGesture(){
        
        // This sets up the long tap to drop the pin.
        let longTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "didLongTapMap:")
        longTap.delegate = self
        longTap.numberOfTapsRequired = 0
        longTap.minimumPressDuration = 0.5
        MapView.addGestureRecognizer(longTap)
    }
    
    func didLongTapMap(gestureRecognizer: UIGestureRecognizer) {
        // Get the spot that was tapped.
        let tapPoint: CGPoint = gestureRecognizer.locationInView(MapView)
        let touchMapCoordinate: CLLocationCoordinate2D = MapView.convertPoint(tapPoint, toCoordinateFromView: MapView)
        
        
        if .Began == gestureRecognizer.state {
            // Delete any existing annotations.
            if MapView.annotations.count != 0 {
                MapView.removeAnnotations(MapView.annotations)
            }
            
            var plottedHowl = MKPointAnnotation()
            plottedHowl.coordinate = touchMapCoordinate
            plottedHowl.title = "Howl Title"
            plottedHowl.subtitle = "This is where the actual howl will go"
            
            newHowlLat = (plottedHowl.coordinate.latitude as Double)
            newHowlLon = (plottedHowl.coordinate.longitude as Double)
            
            newHowlAnnotation = plottedHowl
            
            MapView.addAnnotation(newHowlAnnotation)
            
            howlButton.enabled = true;
            howlButton.setTitle("Howl", forState: UIControlState.Normal)
         
            
            
        }//end outer if
        
        
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue){
  
        
        loadThePoints()
       
        
    }


}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}