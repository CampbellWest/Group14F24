//
//  Driving.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-05.
//

import SwiftUI
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var speed: Double = 0.0 // Speed in m/s
    private var timer: Timer?
    var averageMovingSpeed: Double = 0.0
    var speedInstances: [Double] = []

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateSpeed()
        }
    }

    private func updateSpeed() {
        if let currentLocation = locationManager.location {
            speed = max(currentLocation.speed, 0)
            if speed != 0.0 {
                speedInstances.append(speed)
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            speed = 0.0
        }
    }
    
    func stopTrackingSpeed() -> Double{
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
        return calculateAvertageMovingSpeed()
    }
    
    func calculateAvertageMovingSpeed() -> Double {
        let totalSpeed = speedInstances.reduce(0, +)
        averageMovingSpeed = totalSpeed / Double(speedInstances.count)
        averageMovingSpeed = averageMovingSpeed * 3.6
        print("Average Speed: \(averageMovingSpeed.roundToTwo()) km/h")
        return averageMovingSpeed
    }
}
