//
//  TrackingDetailController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 5/29/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class TrackingDetailController: BaseViewController {
    @IBOutlet fileprivate(set) weak var mapView: MKMapView!
    @IBOutlet fileprivate(set) weak var activeLabel: UILabel!
    @IBOutlet fileprivate(set) weak var durationLabel: UILabel!
    @IBOutlet fileprivate(set) weak var distanceLabel: UILabel!

    var viewModel: TrackingDetailViewModel!

    struct Data {
        var active: String
        var duration: String
        var distance: String
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            activeLabel.text = data.active
            durationLabel.text = data.duration
            distanceLabel.text = data.distance
        }
    }

    override func setupUI() {
        super.setupUI()
        title = Strings.tracking
        configureMapView()
        configInfor()
    }

    private func configureMapView() {
        mapView.delegate = self
        mapView.add(MKPolyline(coordinates: viewModel.coordinatesForMap(), count: viewModel.coordinatesForMap().count))
    }

    private func configInfor() {
        data = viewModel.data()
    }

    @IBAction func save(_ sender: Any) {
        self.viewModel.save(completion: { [weak self](result) in
            guard let this = self else { return }
            switch result {
            case .success(_):
                this.navigationController?.popViewController(animated: true)
            case .failure(let error):
                error.show()
            }
        })
    }

    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension TrackingDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }
}
