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
    @Published var speed: Double = 0.0
    @Published private var speedInstances: [Double] = []
    
    private var locationManager = CLLocationManager()
    private var timer: Timer?
    var averageMovingSpeed: Double = 0.0
    
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
            if speed > 0.0 {
                speedInstances.append(speed)
            }
        }
        print(speedInstances.count)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            speed = 0.0
        }
    }
    
    func stopTrackingSpeed() async throws -> DrivingStats? {
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
        return calculateDrivingStatistics()
    }
    
    func calculateDrivingStatistics() -> DrivingStats {
        var score = 100.0
        let accelerationThreshold = 5.0
        var hardBrakingCount = 0
        var hardAccelerationCount = 0
        var maxSpeed = 0.0
        var finalScore = 0
        var drivingStats: DrivingStats?
        
        let totalSpeed = speedInstances.reduce(0, +)
        let averageSpeed = (totalSpeed / Double(speedInstances.count)) * 3.6
        
        let totalDistance = speedInstances.reduce(0.0) { $0 + ($1 * 0.5) } // Approximate distance in meters
        let lengthFactor = max(1.0, totalDistance / 1000.0) // Normalize by dividing by 1000 (distance in km)
        
        if speedInstances.count > 1 {
            for i in 1..<speedInstances.count {
                let acceleration = (speedInstances[i] - speedInstances[i - 1]) / 0.5
                
                if acceleration > accelerationThreshold {
                    hardAccelerationCount += 1
                    score -= (2 / lengthFactor)
                } else if acceleration < -accelerationThreshold {
                    hardBrakingCount += 1
                    score -= (2 / lengthFactor)
                }
                
                let speedChange = abs(speedInstances[i] - speedInstances[i - 1])
                if speedChange > 0.2 * speedInstances[i - 1] {
                    score -= (1 / lengthFactor)
                }
                if speedInstances[i] > maxSpeed {
                    maxSpeed = speedInstances[i]
                }
            }
            if hardBrakingCount == 0 && hardAccelerationCount == 0 {
                score += 5
            }
            
            maxSpeed = maxSpeed * 3.6
            
            finalScore = min(100, max(0, Int(score)))
            drivingStats = DrivingStats(score: finalScore, maxSpeed: maxSpeed, averageSpeed: averageSpeed)
            
        } else {
            print("Not enough speed data to calculate driving statistics.")
        }
        
        return drivingStats ?? DrivingStats(score: 0, maxSpeed: 0.0, averageSpeed: 0.0)
    }
}
