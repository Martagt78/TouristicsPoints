//
//  ViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit
import Foundation

class PointsViewController: UITableViewController {

    //Codigo necesario para ver la transición de la pantalla y mostrar los detalles de cada POI
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!!")}
        let point = POI.pts[indexPath.row]
        return DetailViewController(coder: coder, points: point)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
}


