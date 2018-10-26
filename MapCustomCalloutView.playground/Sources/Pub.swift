//
//  Atm.swift
//  Saque e Pague
//
//  Created by Gabriel Miranda Silveira on 13/04/18.
//  Copyright © 2018 4all. All rights reserved.
//

import UIKit

public class Pub: Codable {
    var id: String?
    var latitude: Double?
    var longitude: Double?
    let name: String
    let address: String
    let phoneNumber: String
    let photoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
        case phoneNumber = "phone"
        case name
        case photoUrl
        case address
        case id
    }
}
