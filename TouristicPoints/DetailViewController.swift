//
//  DetailViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit


class DetailViewController: UIViewController {
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var transportLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var geocoordinatesLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
   
    
    let detailPoints: DetailPoints
    let pointID: String
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.text = "\(detailPoints.id)"
        titleLabel.text = detailPoints.title
        addressLabel.text = "\(detailPoints.address)"
        transportLabel.text = detailPoints.transport
        emailLabel.text = detailPoints.email
        geocoordinatesLabel.text = "\(detailPoints.geocoordinates)"
        descriptionLabel.text = detailPoints.description
        phoneLabel.text = detailPoints.phone
    }
    
   
    
    init?(coder: NSCoder, detailPoints: DetailPoints) {
        self.detailPoints = detailPoints
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should never be called!")
        
    }
    
    
    func getDetailPoint(withID: String) {

        let urlDetailPOI = URL(string: "http://t21services.herokuapp.com/points/\(id)")! //Pasar ID que queremos mostrar
        var request = URLRequest(url: urlDetailPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: urlDetailPOI) { data, response, error in
            print(data)
            print(response)
            print(error)

            if let data = data {
                if let points = try? JSONDecoder().decode(DetailPoints.self, from: data) {
                    print(points)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }

        }
        task.resume()

    }

}


