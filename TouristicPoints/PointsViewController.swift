//
//  ViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit
import CoreData



class PointsViewController: UITableViewController {
    
    var pointsArray = [PointViewModel]()
    
    //SearchBar
    let searchController = UISearchController(searchResultsController: nil)
    var filteredpointsArray = [PointViewModel]() //array para guardar coincidencias de barra de busqueda
    
    //CoreData
    //Recuperamos los datos que tenemos guardados en fetchRequest
    let fetchRequest = Point.basicFetchRequest()
    
    var point: NSFetchedResultsController<Point>?
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    //Creamos inciador de actividad
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SearchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Place"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        shoWActivityIndicator()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPoint()

    }
    
    //Devuelve true si el texto escrito en la barra está vacio
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //Nos indica si se estan filtrando los resultados
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredpointsArray = pointsArray.filter {(point: PointViewModel) -> Bool in
            //Al usar lowercased comparo tanto minusculas como mayúsculas, no es necesario escribir la palabra tal y como aparece
            return point.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
        
    }
    
    
    func shoWActivityIndicator() {
        //Spinner
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK: - DataSource -
    
    //Método que muestra el numero de celdas que vamos a tener
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredpointsArray.count
        }
        return pointsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PointCell.self)", for: indexPath) as? PointCell
        else {fatalError("Could not create PointCell") }
        var point = pointsArray[indexPath.row]
        
        if isFiltering {
            point = filteredpointsArray[indexPath.row]
        } else {
            point = pointsArray[indexPath.row]
        }
        
        cell.titleLabel?.text = point.title
        return cell
    }
    
    //Obtiene la etiqueta de la celda seleccionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let point = pointsArray[indexPath.row].id
        performSegue(withIdentifier: "detailViewController", sender: point) //inicia la secuencia con el id indicado
        
    }
    
    //Paso el id que he cogido antes a la var pointID en la clase DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewController" {
            guard let detailViewController = segue.destination as?
                    DetailViewController,
                  let pointID = sender as? String else {
                return
            }
            detailViewController.pointID = pointID
            
        }
    }
    
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
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.tableView.reloadData()
                    }
                }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            for i in self.pointsArray {
                                Point.createWith(id: i.id, title: i.title, geocoordinates: i.geocoordinates, using: MyPersistentContainer.persistentContainer.viewContext)
                                MyPersistentContainer.saveContext()
                                
                            }
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    print("Invalid Response")
                    self.refreshDataCore()
                    
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
       
        task.resume()
       
        
    }
    
}


extension PointsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
}


