//
//  FarmacyOnMapViewController.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 12/05/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import UIKit
import MapKit

class FarmacyOnMapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var lat: Double = 0;
    var long: Double = 0;
    var name: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openMapForPlace()
        // Do any additional setup after loading the view.
    }
    
    func setPinUsingMKPlacemark(location: CLLocationCoordinate2D) {
       let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = self.name
       let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       map.setRegion(coordinateRegion, animated: true)
       map.addAnnotation(pin)
    }
    
    func openMapForPlace() {
        let coordinates = CLLocationCoordinate2DMake(self.lat, self.long)
        setPinUsingMKPlacemark(location: coordinates)
    }

}
