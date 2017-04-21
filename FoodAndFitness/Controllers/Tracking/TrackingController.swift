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

class TrackingController: BaseViewController {
    @IBOutlet fileprivate(set) weak var mapView: MKMapView!

    lazy fileprivate var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.distanceFilter = 10
        return manager
    }()
    lazy fileprivate var locations: [CLLocation] = [CLLocation]()
    fileprivate var seconds: Double = 0.0
    fileprivate var distance: Double = 0.0
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
    }

    private func configureTimer() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .commonModes)
        }
    }

    @objc private func eachSecond() {
        seconds += 1
        let secondsQuantity = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        print(secondsQuantity.description)
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        print(distanceQuantity.description)
        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        print(paceQuantity.description)
    }

    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // MARK: - Action Functions
    @IBAction func start(_ sender: Any) {
        configureTimer()
        startUpdatingLocation()
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
                    if let lastLocation = self.locations.last {
                        coords.append(lastLocation.coordinate)
                        distance += location.distance(from: lastLocation)
                    }
                    coords.append(location.coordinate)
                    mapView.add(MKPolyline(coordinates: coords, count: coords.count))
                }
                self.locations.append(location)
            }
        }
    }
}
