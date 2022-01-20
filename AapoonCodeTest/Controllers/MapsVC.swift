//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationUpdate {
    func  locationPassing(address:String,lat:Double,long:Double)
}

class MapsVC: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    var delegate:LocationUpdate!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var myLocation:CLLocationCoordinate2D?
    static var enable:Bool = true
    var selectedUserLat:Double!
    var selectedUserLong:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        self.navigationItem.title = "Search location"
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        if CLLocationManager.locationServicesEnabled() {
            if MapsVC.enable {
                locationManager.stopUpdatingHeading()
                //sender.titleLabel?.text = "Enable"
            }else{
                locationManager.startUpdatingLocation()
                //sender.titleLabel?.text = "Disable"
            }
            MapsVC.enable = !MapsVC.enable
        }
        addLongPressGesture()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.showsUserLocation = false
    }
    
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(MapsVC.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    
    //MARK:- SUBMIT BTN ACTION
    @IBAction func submitBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate.locationPassing(address: self.address_lbl.text ?? "",lat:selectedUserLat ,long:selectedUserLong)
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        self.resetTracking()
        self.mapView.addAnnotation(annot)
         
        self.getAddressFromLatLon(pdblLatitude: "\(touchMapCoordinate.latitude)", withLongitude: "\(touchMapCoordinate.longitude)")
       // self.centerMap(touchMapCoordinate)
    }
    
    func resetTracking(){
        if (mapView.showsUserLocation){
            
            mapView.showsUserLocation = false
            self.mapView.removeAnnotations(mapView.annotations)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        let span = MKCoordinateSpan(latitudeDelta:spanX, longitudeDelta: spanY)
        
        let newRegion = MKCoordinateRegion(center:center , span: span)
        mapView.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        getAddressFromLatLon(pdblLatitude: "\(center.latitude)", withLongitude: "\(center.longitude)")
        // self.lable.text = message
        myLocation = center
    }
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String)
    {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
       
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        selectedUserLong = lon
               selectedUserLat = lat
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0
                {
                    let pm = placemarks![0]
                     print(pm.country)
                    //print(pm.locality)
//                    self.mapaddcontry = pm.country!
//                    self.mapaddrState = pm.subLocality!
//                    self.mapaddrcity = pm.locality!
//                    self.mapaddrPincode = pm.postalCode!

                    //self.mainname = pm.locality!
                    print(pm.subLocality)
                   // self.subname = pm.subLocality!
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil
                    {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil
                    {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil
                    {
                        addressString = addressString + pm.postalCode! + " "
                    }

                     self.address_lbl.text = addressString
                    print(addressString)
                    ///self.mapaddrtxt.text = addressString
                   // self.location_name = addressString

                }
        })

    }
    
    
}

extension MapsVC:CLLocationManagerDelegate,MKMapViewDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            view = dequeueView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.pinTintColor =  .red
        return view
    }
}
