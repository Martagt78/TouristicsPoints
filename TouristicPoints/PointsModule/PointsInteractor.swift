//
//  PointsInteractor.swift
//  TouristicPoints
//
//  Created by Marta García on 6/8/21.
//

import CoreData
import UIKit



protocol PointsInteractorInterface {
    
    var presenter: PointsPresenterInterface? {get set}
    
    //AddressListPresenter -> AddressListInteractor
    func getPoint()
    
}


class PointsInteractor: UITableViewController, PointsInteractorInterface {
    
    // Reference to the Presenter's interface.
    var presenter: PointsPresenterInterface?
    
    var pointsArray = [PointViewModel]()
    
    //MARK: - CoreData -
    //Recuperamos los datos que tenemos guardados en fetchRequest
    let fetchRequest = Point.basicFetchRequest()
    var point: NSFetchedResultsController<Point>?
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    func refreshDataCore() {
        let sort = NSSortDescriptor(key: #keyPath(Point.title), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            point = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: MyPersistentContainer.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            //Solicitamos la recuperación de los datos
            try point?.performFetch()
            //ponemos esos datos en el array pointArray, y lo recorremos para ir creando cada item
            if let pointArray = point?.fetchedObjects {
                for p in pointArray {
                    let item = PointViewModel(id: p.id, title: p.title, geocoordinates: p.geocoordinates)
                    //añadimos cada item creado a nuestro array inicial
                    pointsArray.append(item)
                }
                self.presenter?.handlePointInformation(arrayPoints: self.pointsArray)
            }
            
        } catch let error as NSError {
            self.presenter?.handlePointFetchError(error: error)
        }
    }
    
    func getPoint() {
        let urlPOI = URL(string: "http://t21services.herokuapp.com/points")!
        var request = URLRequest(url: urlPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlPOI) { data, response, error in
            if let data = data {
                if let points = try? JSONDecoder().decode(PointsViewModel.self, from: data) {
                    self.pointsArray = points.list
                    if let appDelegate = self.delegate {
                        appDelegate.clearDataPoint()
                        for i in self.pointsArray {
                            Point.createWith(id: i.id, title: i.title, geocoordinates: i.geocoordinates, using: MyPersistentContainer.persistentContainer.viewContext)
                            MyPersistentContainer.saveContext()
                        }
                        //llamar presenterhandlepointsinformation
                        self.presenter?.handlePointInformation(arrayPoints: self.pointsArray) //interactor->presenter
                        
                    }
                } else {
                    print("Invalid Response")
                    self.refreshDataCore()
                    
                }
            } else if let error = error {
                //llamar presenter informando error
                self.presenter?.handlePointFetchError(error: error)
            }
        }
        task.resume()
    }
    
}
