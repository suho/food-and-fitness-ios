//
//  TrackingController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/20/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

final class TrackingController: BaseViewController {
    @IBOutlet fileprivate(set) weak var mapView: MKMapView!
    @IBOutlet fileprivate(set) weak var activeLabel: UILabel!
    var viewModel: TrackingViewModel = TrackingViewModel()

    enum Action {
        case starting
        case stopping
    }

    fileprivate var action: Action = .stopping

    lazy fileprivate var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = 10
        return manager
    }()

    fileprivate var timer: Timer?
    fileprivate let healthKitStore: HKHealthStore = HKHealthStore()

    // MARK: - Cycle Life
    override var isNavigationBarHidden: Bool {
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func setupUI() {
        super.setupUI()
        configureMapView()
    }

    // MARK: - Private Functions
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    private func configureTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .commonModes)
        }
    }

    @objc private func eachSecond() {
        viewModel.seconds += 1
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: viewModel.seconds)
        print(secondsQuantity.description)
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: viewModel.distance)
        print(distanceQuantity.description)
        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: viewModel.seconds / viewModel.distance)
        print(paceQuantity.description)
    }

    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Action Functions
    @IBAction func startOrStop(_ sender: Any) {
        switch action {
        case .starting:
            stopUpdatingLocation()
            timer?.invalidate()
            print("Distance: \(viewModel.distance)")
            print("Duration: \(viewModel.seconds)")
            action = .stopping
            viewModel.save(completion: { [weak self](result) in
                guard let this = self else { return }
                switch result {
                case .success(_):
                    this.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    error.show()
                }
            })
        case .stopping:
            configureTimer()
            startUpdatingLocation()
            action = .starting
        }
    }

    @IBAction func chooseActive(_ sender: Any) {
        let chooseActiveTrackingController = ChooseActiveTrackingController()
        chooseActiveTrackingController.delegate = self
        present(chooseActiveTrackingController, animated: true) {
            UIView.animate(withDuration: 0.2) {
                chooseActiveTrackingController.view.backgroundColor = Color.blackAlpha20
            }
        }
    }
}

// MARK: - ChooseActiveTrackingControllerDelegate
extension TrackingController: ChooseActiveTrackingControllerDelegate {
    func viewController(_ viewController: ChooseActiveTrackingController, needsPerformAction action: ChooseActiveTrackingController.Action) {
        switch action {
        case .dismiss(let active):
            activeLabel.text = active.title
            viewModel.active = active
        }
    }
}

// MARK: - MKMapViewDelegate
extension TrackingController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }
}

// MARK: - CLLocationManagerDelegate
extension TrackingController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let recent = location.timestamp.timeIntervalSinceNow
            if abs(recent) < 10 && location.horizontalAccuracy < 20 {
                if locations.isNotEmpty {
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView.setRegion(region, animated: true)
                    var coords: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
                    if let lastLocation = viewModel.locations.last {
                        coords.append(lastLocation.coordinate)
                        viewModel.distance += location.distance(from: lastLocation)
                    }
                    coords.append(location.coordinate)
                    mapView.add(MKPolyline(coordinates: coords, count: coords.count))
                }
                viewModel.locations.append(location)
            }
        }
    }
}
