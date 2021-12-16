//
//  PointsBuilder.swift
//  TouristicPoints
//
//  Created by Marta García on 13/8/21.
//

import UIKit


class PointsBuilder {
    
    class func createModule(pointsRef: PointsViewController)  {
        
        let presenter: PointsPresenterInterface = PointsPresenter()

        // Connect layers
        pointsRef.presenter = presenter
        pointsRef.presenter?.router = PointsRouter()
        pointsRef.presenter?.view = pointsRef
        pointsRef.presenter?.interactor = PointsInteractor()
        pointsRef.presenter?.interactor?.presenter = presenter
        
    }
}
