//
//  DetailViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit


class DetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var coordinatesLabel: UILabel!
   
    
    let points: Points
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = points.title
        idLabel.text = "\(points.id)"
        coordinatesLabel.text = "\(points.geocoordinates)"
    }
    
   
    
    init?(coder: NSCoder, points: Points) {
        self.points = points
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should never be called!")
        
    }

}


