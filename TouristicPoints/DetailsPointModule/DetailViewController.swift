//
//  DetailViewController.swift
//  TouristicPoints
//
//  Created by Marta García on 2/7/21.
//

import UIKit

protocol DetailsViewInterface {
    
    func configureOutlets(detailPoints: DetailsViewModel)
    func showDetailProgress()
    func hideDetailProgress()
    
}

class DetailViewController: UIViewController, DetailsViewInterface {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var transportLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var geocoordinatesLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var descriptionText: UITextView!
    
    
    //MARK: Reference to the Presenter's interface.
    var presenter: DetailPresenterInterface?
    
    var pointID: String = ""
    
    var detailPoints: DetailsViewModel?
    
    var activityDetailIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailsBuilder.createModule(pointsDetailRef: self)
        configureActivityDetailIndicator()
        presenter?.getDetailPoint(pointID: pointID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureOutlets(detailPoints: DetailsViewModel) {
        titleLabel.text = detailPoints.title
        addressLabel.text = "\(detailPoints.address)"
        transportLabel.text = detailPoints.transport
        emailLabel.text = detailPoints.email
        geocoordinatesLabel.text = "\(detailPoints.geocoordinates)"
        phoneLabel.text = detailPoints.phone
        descriptionText.text = detailPoints.description
    }
    
    //MARK: - ActivityIndicator -
    func configureActivityDetailIndicator() {
        //Spinner
        activityDetailIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityDetailIndicator)
        activityDetailIndicator.startAnimating()
        activityDetailIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityDetailIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showDetailProgress() {
        activityDetailIndicator.startAnimating()
        activityDetailIndicator.isHidden = false
    }
    
    func hideDetailProgress() {
        activityDetailIndicator.stopAnimating()
        activityDetailIndicator.isHidden = true
    }
}


