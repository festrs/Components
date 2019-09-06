//
//  AtmAnnotation.swift
//  Saque e Pague
//
//  Created by Gabriel Miranda Silveira on 13/04/18.
//  Copyright © 2018 4all. All rights reserved.
//

import UIKit
import MapKit

public class PubAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    var isSelected = true
    var name: String?
    var title: String?
    var subtitle: String?
    var phone: String?
    var imageUrl: URL?
    
    public init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    public init(pub: Pub) {
        self.coordinate = CLLocationCoordinate2D(latitude: pub.latitude ?? 0, longitude: pub.longitude ?? 0)
        self.name = pub.name
        self.title = pub.name
        self.subtitle = pub.address
        self.imageUrl = pub.photoUrl
        self.phone = pub.phoneNumber
    }
}
