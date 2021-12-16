//
//  ViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit


// MARK: - Protocol to be defined at ViewController
protocol PointsViewInterface {
    
    func showProgress()
    func hideProgress()
    func reloadData(array: [PointViewModel])
    
}

class PointsViewController: UIViewController, PointsViewInterface  {
    
    // MARK: Reference to the Presenter's interface.
    var presenter: PointsPresenterInterface?
    
    var detailPoints: DetailsViewModel?
    var pointsArray = [PointViewModel]()
    
    //SearchBar
    let searchController = UISearchController(searchResultsController: nil)
    var filteredpointsArray = [PointViewModel]() //array para guardar coincidencias de barra de busqueda
    
    //Creamos inciador de actividad
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PointsBuilder.createModule(pointsRef: self)
        setupInitialView()
        searchBar()
        configureActivityIndicator()
        presenter?.getPoint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - SearchBar -
    
    func searchBar() {
        //SearchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Place"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    //MARK: - ActivityIndicator -
    
    func configureActivityIndicator() {
        //Spinner
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showProgress() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideProgress() {
        Dispatch.DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func setupInitialView() {
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func reloadData(array: [PointViewModel]) { 
        DispatchQueue.main.async {
            self.pointsArray = array
            self.tableView?.reloadData()
        }
    }
}

extension PointsViewController:  UITableViewDataSource, UITableViewDelegate {
    
    //Método que muestra el numero de celdas que vamos a tener
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredpointsArray.count
        }
        return pointsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PointCell.self)", for: indexPath) as! PointCell
        //else {fatalError("Could not create PointCell") }
        var point = pointsArray[indexPath.row]
        if isFiltering {
            point = filteredpointsArray[indexPath.row]
        } else {
            point = pointsArray[indexPath.row]
        }
        
        cell.titleLabel?.text = point.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Obtiene la etiqueta de la celda seleccionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pointID = pointsArray[indexPath.row].id
        presenter?.pushViewController(with: pointsArray[indexPath.row], from: self, pointID: pointID)
    }
    
    // Paso el id que he cogido antes a la var pointID en la clase DetailViewController
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
}

extension PointsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


