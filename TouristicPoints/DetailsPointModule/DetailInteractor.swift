//
//  DetailInteractor.swift
//  TouristicPoints
//
//  Created by Marta García on 9/8/21.
//

import UIKit
import CoreData

protocol DetailInteractorInterface {
    
    var detailPresenter: DetailPresenterInterface? {get set}
    
    // AddressListPresenter -> AddressListInteractor
    func refreshDetailDataCore(pointID: String)
    func updateContext(detailPoints: DetailsViewModel, pointID: String)
    func getDetailPoint(pointID: String)
    
}

class DetailInteractor: DetailInteractorInterface {
    
    // Reference to the Presenter's interface.
    var detailPresenter: DetailPresenterInterface?

    //MARK: - CoreData -
    //Recuperamos los datos que tenemos guardados en fetchRequest
    let fetchDetailRequest = Details.basicDetailFetchRequest()
    var detail: NSFetchedResultsController<Details>?
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    func refreshDetailDataCore(pointID: String) {
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
                        let item = DetailsViewModel(id: i.idDetails, title: i.titleDetails, address: i.address, transport: i.transport, email: i.email, geocoordinates: i.geocoordinatesDetails, description: i.descriptionplace, phone: i.phone)
                        self.detailPresenter?.configureOutlets(detailPoints: item)
                    }
                }
            }
            
        } catch let error as NSError {
            self.detailPresenter?.handleDetailFetchError(error: error)
        }
    }
    
    func updateContext(detailPoints: DetailsViewModel, pointID: String) {
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
                    self.detailPresenter?.hideDetailProgress()
                    self.detailPresenter?.configureOutlets(detailPoints: detailPoints)
                }
            }
            
        } catch let error as NSError {
            self.detailPresenter?.handleDetailFetchError(error: error)
        }
    }
    
    func getDetailPoint(pointID: String) {
        let urlDetailPOI = URL(string: "http://t21services.herokuapp.com/points/\(pointID)")! //Pasar ID que queremos mostrar
        var request = URLRequest(url: urlDetailPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlDetailPOI) { data, response, error in
            if let data = data {
                if let dpoints = try? JSONDecoder().decode(DetailsViewModel.self, from: data) {
                    self.updateContext(detailPoints: dpoints, pointID: pointID)
                } else {
                    print("Invalid Response")
                    self.refreshDetailDataCore(pointID: pointID)
                }
            } else if let error = error {
                self.detailPresenter?.handleDetailFetchError(error: error)
            }
        }
        task.resume()
    }
}
