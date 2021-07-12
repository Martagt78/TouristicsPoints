//
//  DetailViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit
import CoreData


class DetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var transportLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var geocoordinatesLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    
    var detailPoints: DetailPoints?
    var pointID: String = ""
    
    
    let fetchRequest = Details.basicDetailFetchRequest()
    var detail: NSFetchedResultsController<Details>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailPoint()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Coredata
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let sort = NSSortDescriptor(key: #keyPath(Details.titleDetails), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            detail = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: delegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try detail?.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func configureOutlets(detailPoints: DetailPoints ) {
        titleLabel.text = detailPoints.title
        addressLabel.text = "\(detailPoints.address)"
        transportLabel.text = detailPoints.transport
        emailLabel.text = detailPoints.email
        geocoordinatesLabel.text = "\(detailPoints.geocoordinates)"
        phoneLabel.text = detailPoints.phone
        descriptionText.text = detailPoints.description
        
    }
    
    func getDetailPoint() {
        
        let urlDetailPOI = URL(string: "http://t21services.herokuapp.com/points/\(self.pointID)")! //Pasar ID que queremos mostrar
        var request = URLRequest(url: urlDetailPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlDetailPOI) { data, response, error in
            if let data = data {
                if let dpoints = try? JSONDecoder().decode(DetailPoints.self, from: data) {
                    DispatchQueue.main.async {
                        self.configureOutlets(detailPoints: dpoints)
                    }
                    
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


