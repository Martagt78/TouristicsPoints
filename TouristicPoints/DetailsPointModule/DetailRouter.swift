//
//  DetailRouter.swift
//  TouristicPoints
//
//  Created by Marta García on 9/8/21.
//

import UIKit

protocol DetailRouterInterface {
    
    // AddressListPresenter -> AddressListRouter
    func presentPopup(error: Error)
    
}

class DetailRouter: DetailRouterInterface {
    
    var viewControllerRuterDetail: DetailViewController?
    var presenter: DetailPresenter?
    var navigationController: UINavigationController?
    var point: DetailsViewModel?
    
    //PopUp para mostrar error a la hora de pedir datos
    func presentPopup(error: Error) {
        let alertControllerDetail = UIAlertController(title: "FetchFailed", message: "HTTP Request Failed \(error)", preferredStyle: .alert)
        alertControllerDetail.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.navigationController?.visibleViewController?.present(alertControllerDetail, animated: true, completion: nil)
    }
}




