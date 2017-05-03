//
//  DeliveryViewController.swift
//  FoodTakr
//
//  Created by Ed McCormic on 5/2/17.
//  Copyright © 2017 Swiftbeard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DeliveryViewController: UIViewController {
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var lbCustomerName: UILabel!
    @IBOutlet weak var lbCustomerAddress: UILabel!
    @IBOutlet weak var imgCustomerAvatar: UIImageView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var bComplete: UIButton!
    
    
    var orderId: Int?
    
    var destination: MKPlacemark?
    var source: MKPlacemark?
    
    var locationManager: CLLocationManager!
    var driverPin: MKPointAnnotation!
    var lastLocation: CLLocationCoordinate2D!
    
    var timer = Timer()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        // Show drivers location
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            self.map.showsUserLocation = false
        }
        
        // Running the updating location process
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLocation(_:)), userInfo: nil, repeats: true)
    }
    
    
    
    
    func updateLocation(_ sender: AnyObject) {
        
        APIManager.shared.updateLocation(location: self.lastLocation) { (json) in
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        
        
        APIManager.shared.getCurrentDriverOrder { (json) in
            
            let order = json["order"]
            if let id = order["id"].int, order["status"] == "On the Way" {
                self.orderId = id
                
                let from = order["address"].string!
                let to = order["restaurant"]["address"].string!
                
                let customerName = order["customer"]["name"].string!
                let customerAvatar = order["customer"]["address"].string!
                
                self.lbCustomerName.text = customerName
                self.lbCustomerAddress.text = from
                
                // CHECK FOR DEFAULT IMAGE TODO
                self.imgCustomerAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: customerAvatar)!))
                self.imgCustomerAvatar.layer.cornerRadius = 50/2
                self.imgCustomerAvatar.clipsToBounds = true
                
                self.getLocation(from, "Customer", { (start) in
                    self.source = start
                    
                    self.getLocation(to, "Restaurant", { (end) in
                        self.destination = end
                    })
                })
            } else {
                
                self.map.isHidden = true
                self.viewInfo.isHidden = true
                self.bComplete.isHidden = true
                
                let lbMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
                lbMessage.center = self.view.center
                lbMessage.textAlignment = NSTextAlignment.center
                lbMessage.text = "You don't have any orders for delivery."
                
                self.view.addSubview(lbMessage)
                
            }
        }
    }
    
    @IBAction func completeOrder(_ sender: AnyObject) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            APIManager.shared.completeOrder(orderId: self.orderId!, completionHandler: { (json) in
                
                if json != nil {
                    
                    self.timer.invalidate()
                    self.locationManager.stopUpdatingLocation()
                    
                    self.performSegue(withIdentifier: "ViewOrders", sender: self)
                    
                }
            })
        }
        
        let alertView = UIAlertController(title: "Complete Order", message: "Are you sure?", preferredStyle: .alert)
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    

}

extension DeliveryViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    func getLocation(_ address: String, _ title: String, _ completionHandler: @escaping (MKPlacemark) -> Void){
        
        
        let geocoder = CLGeocoder()
        
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            if (error != nil) {
                print("Error: ", error)
                
            }
            if let placemark = placemarks?.first {
                
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                
                // Create a pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = title
                self.map.addAnnotation(dropPin)
                completionHandler(MKPlacemark.init(placemark: placemark))
            }
        }
        
    }
    
    
    
    
}

extension DeliveryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        self.lastLocation = location.coordinate
        
        if driverPin != nil {
            driverPin.coordinate = self.lastLocation
        } else {
            driverPin = MKPointAnnotation()
            driverPin.coordinate = self.lastLocation
            self.map.addAnnotation(driverPin)
        }
        
        // Reset zoom
        var zoomRect = MKMapRectNull
        for annotation in self.map.annotations {
            
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }
        
        let insetWidth = -zoomRect.size.width * 0.2
        let insetHeight = -zoomRect.size.height * 0.2
        let insetRect = MKMapRectInset(zoomRect, insetWidth, insetHeight)
        
        self.map.setVisibleMapRect(insetRect, animated: true)
        
    }
}

