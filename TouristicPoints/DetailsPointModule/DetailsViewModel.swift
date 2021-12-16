//
//  DetailsViewModel.swift
//  TouristicPoints
//
//  Created by Marta García on 10/8/21.
//

import UIKit


struct DetailsViewModel: Codable {
    
    var id: String
    let title: String
    let address: String
    let transport: String
    let email: String
    let geocoordinates: String
    let description: String
    let phone: String
}
