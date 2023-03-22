//
//  SchoolLocationTableViewCell.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/22/23.
//

import Foundation
import UIKit
import MapKit

class SchoolLocationTableViewCell: UITableViewCell {

    @IBOutlet var schoolLocationMapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func addAnnotaionWithCoordinates(_ schoolCoordinates: CLLocationCoordinate2D){
        let schoolAnnotation = MKPointAnnotation()
        schoolAnnotation.coordinate = schoolCoordinates
        self.schoolLocationMapView.addAnnotation(schoolAnnotation)
        let latDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: latDelta)
        let coordinateRegion = MKCoordinateRegion(center: schoolAnnotation.coordinate, span: span)
        let adjustRegion = self.schoolLocationMapView.regionThatFits(coordinateRegion)
        self.schoolLocationMapView.setRegion(adjustRegion, animated:true)
    }

}
