//
//  PointsPresenter.swift
//  TouristicPoints
//
//  Created by Marta García on 6/8/21.
//

import UIKit

/*
 * Protocol that defines the commands sent from the View to the Presenter.
 */
protocol PointsPresenterInterface {
    
    var interactor: PointsInteractorInterface? {get set}
    var view: PointsViewInterface? {get set}
    var router: PointsRouterInterface? {get set}
    
    func getPoint()
    func handlePointFetchError(error: Error)
    func pushViewController(with points: PointViewModel, from view: UIViewController, pointID: String)
    func handlePointInformation(arrayPoints: [PointViewModel])
    
}


class PointsPresenter: PointsPresenterInterface {
  
    // Reference to the View interface.
    var view: PointsViewInterface?
    // Reference to the Interactor interface.
    var interactor: PointsInteractorInterface?
    // Reference to the Router interface.
    var router: PointsRouterInterface?
    
    func getPoint() {
        view?.showProgress()
        interactor?.getPoint() //presenter->interactor
    }
    
    func pushViewController(with points: PointViewModel, from view: UIViewController, pointID: String) {
        router?.pushPointsViewController(with: points, from: view, pointID: pointID)
    }
    
    func handlePointFetchError(error: Error) {
        router?.presentPopup(error: error)
    }
    
    func handlePointInformation(arrayPoints: [PointViewModel]) {
        view?.hideProgress()
        view?.reloadData(array: arrayPoints) //presenter->view
    }
}
