//
//  PointsRouter.swift
//  TouristicPoints
//
//  Created by Marta García on 6/8/21.
//

import UIKit

protocol PointsRouterInterface {
    
    // AddressListPresenter -> AddressListRouter
    func pushPointsViewController(with points: PointViewModel, from view: UIViewController, pointID: String)
    func presentPopup(error: Error)
}

class PointsRouter: PointsRouterInterface {
    
    var viewControllerRuter: PointsViewController?
    var presenter: PointsPresenter?
    var navigationController: UINavigationController?
    
    func pushPointsViewController(with points: PointViewModel, from view: UIViewController, pointID: String) {
        if let  viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController {
            viewController.pointID = pointID
            view.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //PopUp para mostrar error a la hora de pedir datos
    func presentPopup(error: Error) {
        let alertController = UIAlertController(title: "FetchFailed", message: "HTTP Request Failed \(error)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.navigationController?.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
}













