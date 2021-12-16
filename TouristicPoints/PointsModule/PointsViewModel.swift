//
//  Points.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit

struct PointsViewModel: Codable {
    
    var list: [PointViewModel]
}

struct PointViewModel: Codable {
    
    let id: String
    let title: String
    let geocoordinates: String
}





