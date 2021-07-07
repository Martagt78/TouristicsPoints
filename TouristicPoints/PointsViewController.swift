//
//  ViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit
import Foundation

class PointsViewController: UITableViewController, UISearchBarDelegate {
    
    //Codigo necesario para ver la transición de la pantalla y mostrar los detalles de cada POI
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!!")}
        let detailPoint = dPOI.dpts[indexPath.row]
        return DetailViewController(coder: coder, detailPoints: detailPoint)
    }
    
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Codigo para incluir la barra de busqueda
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search"
        tableView.tableHeaderView = searchController?.searchBar
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPoint()
        getDetailPoint(withID id: String)
        self.tableView.reloadData()

    }
    
    
    //MARK: - DataSource -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Método que muestra el numero de celdas que vamos a tener
        return POI.pts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PointCell.self)", for: indexPath) as? PointCell
        else {fatalError("Could not create PointCell") }
        let point = POI.pts[indexPath.row]
        cell.titleLabel.text = point.title
        
        return cell
    }
    
    
    func getPoint() {
        
        let urlPOI = URL(string: "http://t21services.herokuapp.com/points")!
        var request = URLRequest(url: urlPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlPOI) { data, response, error in
            //print(data)
            //print(response)
            //print(error)
            
            if let data = data {
                if let points = try? JSONDecoder().decode(Places.self, from: data) {
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
    
    
    
    func getDetailPoint(withID id: String) {
        
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


