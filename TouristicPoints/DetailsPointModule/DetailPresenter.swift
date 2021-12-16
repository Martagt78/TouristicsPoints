//
//  DetailPresenter.swift
//  TouristicPoints
//
//  Created by Marta García on 9/8/21.
//

import UIKit

/*
 * Protocol that defines the commands sent from the View to the Presenter.
 */
protocol DetailPresenterInterface {
    
    var detailInteractor: DetailInteractorInterface? {get set}
    var detailView: DetailsViewInterface? {get set}
    var detailRouter: DetailRouterInterface? {get set}
    
    func getDetailPoint(pointID: String)
    func configureOutlets(detailPoints: DetailsViewModel)
    func handleDetailFetchError(error: Error)
    func hideDetailProgress()
    
}

class DetailPresenter: DetailPresenterInterface {
    
    // Reference to the View interface.
    var detailView: DetailsViewInterface?
    // Reference to the Interactor interface.
    var detailInteractor: DetailInteractorInterface?
    // Reference to the Router interface.
    var detailRouter: DetailRouterInterface?
    
    func getDetailPoint(pointID: String) {
        detailView?.showDetailProgress()
        detailInteractor?.getDetailPoint(pointID: pointID)
    }
    
    func configureOutlets(detailPoints: DetailsViewModel) {
        detailView?.configureOutlets(detailPoints: detailPoints)
    }
    
    func handleDetailFetchError(error: Error) {
        detailRouter?.presentPopup(error: error)
    }
    
    func hideDetailProgress() {
        detailView?.hideDetailProgress()
    }

}
