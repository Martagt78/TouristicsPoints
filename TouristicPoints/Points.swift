//
//  Points.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit

struct Places: Codable {
  var list: [Place]
}

struct Place: Codable {
    let id: String
    let title: String
    let geocoordinates: String
}

struct  DetailPoints: Codable {
    var id: String
    let title: String
    let address: String
    let transport: String
    let email: String
    let geocoordinates: String
    let description: String
    let phone: String
}

    
    

