//
//  ViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit
import Foundation

class PointsViewController: UITableViewController, UISearchBarDelegate {
    
    var pointsArray = [Place]()
    
    //Codigo necesario para ver la transición de la pantalla y mostrar los detalles de cada POI
    //Esto tendría que quitarlo al pasarle el id por parámetros mediante didSelectRowAt??
    //Cambio
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!!")}
        let detailPoint = dPOI.dpts[indexPath.row]
        let pointID = "" //Esto no se si está bien, preguntar
        return DetailViewController(coder: coder, detailPoints: detailPoint, pointID: pointID)
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
        
    }
    
    
    //MARK: - DataSource -
    
    //Método que muestra el numero de celdas que vamos a tener
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PointCell.self)", for: indexPath) as? PointCell
        else {fatalError("Could not create PointCell") }
        let point = pointsArray[indexPath.row]
        cell.titleLabel?.text = point.title
        return cell
    }
    
    //Obtiene la etiqueta de la celda seleccionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let point = pointsArray[indexPath.row].id
        performSegue(withIdentifier: "ID", sender: point) //inicia la secuencia con el id indicado
        //print(point.id)
    }
    
    //Paso el id que he cogido antes a la var pointID en la clase DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ID" {
            guard let detailViewController = segue.destination as?
            DetailViewController,
                  let pointID = sender as? String else {
                return
            }
            detailViewController.pointID = pointID
        }
    }
    
    
    
   
    func getPoint() {
        
        let urlPOI = URL(string: "http://t21services.herokuapp.com/points")!
        var request = URLRequest(url: urlPOI)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlPOI) { data, response, error in
            if let data = data {
                if let points = try? JSONDecoder().decode(Places.self, from: data) {
                    self.pointsArray = points.list
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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


