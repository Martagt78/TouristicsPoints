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
    
    //CoreData
    //Recuperamos los datos que tenemos guardados en fetchRequest
    let fetchDetailRequest = Details.basicDetailFetchRequest()
    
    var detail: NSFetchedResultsController<Details>?
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDetailPoint()
        
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
    
    
    func refreshDetailDataCore() {
        let sort = NSSortDescriptor(key: #keyPath(Details.titleDetails), ascending: true)
        fetchDetailRequest.sortDescriptors = [sort]
        fetchDetailRequest.predicate = NSPredicate(format: "idDetails = \(pointID)")
        do {
            detail = NSFetchedResultsController(fetchRequest: fetchDetailRequest, managedObjectContext: MyPersistentContainer.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            //Solicitamos la recuperación de los datos
            try detail?.performFetch()
            if let place = self.detail?.fetchedObjects {
                for i in place {
                    DispatchQueue.main.async {
                        let item = DetailPoints(id: i.idDetails, title: i.titleDetails, address: i.address, transport: i.transport, email: i.email, geocoordinates: i.geocoordinatesDetails, description: i.descriptionplace, phone: i.phone)
                        self.configureOutlets(detailPoints: item)
                        
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func updateContext(detailPoints: DetailPoints) {
        let sort = NSSortDescriptor(key: #keyPath(Details.titleDetails), ascending: true)
        fetchDetailRequest.sortDescriptors = [sort]
        fetchDetailRequest.predicate = NSPredicate(format: "idDetails = \(pointID)")
        do {
            detail = NSFetchedResultsController(fetchRequest: fetchDetailRequest, managedObjectContext: MyPersistentContainer.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            //Solicitamos la recuperación de los datos
            try detail?.performFetch()
            if let place = self.detail?.fetchedObjects {
                if place.count > 0 {
                    let manageObject = place[0]
                    manageObject.titleDetails = detailPoints.title
                    manageObject.geocoordinatesDetails = detailPoints.geocoordinates
                    manageObject.address = detailPoints.address
                    manageObject.descriptionplace = detailPoints.description
                    manageObject.email = detailPoints.email
                    manageObject.transport = detailPoints.transport
                    MyPersistentContainer.saveContext()
                    
                    
                } else {
                    Details.createWith(id: detailPoints.id, title: detailPoints.title, geocoordinates: detailPoints.geocoordinates, address: detailPoints.address, description: detailPoints.description, email: detailPoints.email, phone: detailPoints.phone, transport: detailPoints.transport, using: MyPersistentContainer.persistentContainer.viewContext)
                    
                }
                DispatchQueue.main.async {
                    self.configureOutlets(detailPoints: detailPoints)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    func getDetailPoint() {
        let urlDetailPOI = URL(string: "http://t21services.herokuapp.com/points/\(self.pointID)")! //Pasar ID que queremos mostrar
        var request = URLRequest(url: urlDetailPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlDetailPOI) { data, response, error in
            if let data = data {
                if let dpoints = try? JSONDecoder().decode(DetailPoints.self, from: data) {
                    self.updateContext(detailPoints: dpoints)
                } else {
                    print("Invalid Response")
                    self.refreshDetailDataCore()
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
            
        }
        task.resume()
        
    }
    
}


