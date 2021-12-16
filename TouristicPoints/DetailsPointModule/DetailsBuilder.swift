//
//  DetailsBuilder.swift
//  TouristicPoints
//
//  Created by Marta García on 13/8/21.
//

import UIKit

class DetailsBuilder {
    
    class func createModule(pointsDetailRef: DetailViewController)  {
        
        let presenter: DetailPresenterInterface = DetailPresenter()

        // Connect layers
        pointsDetailRef.presenter = presenter
        pointsDetailRef.presenter?.detailRouter = DetailRouter()
        pointsDetailRef.presenter?.detailView = pointsDetailRef
        pointsDetailRef.presenter?.detailInteractor = DetailInteractor()
        pointsDetailRef.presenter?.detailInteractor?.detailPresenter = presenter

        
    }
    
}
