//
//  Database.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-12.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Database: ObservableObject {
    
    func saveScore(drivingStats: DrivingStats) {
        
        if drivingStats.maxSpeed == 0.0 {
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let currentDate = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium

        let formattedDate = dateFormatter.string(from: currentDate)
        
        let newId = UUID().uuidString
        let newScore = Stats(score: drivingStats.score,
                             maxSpeed: drivingStats.maxSpeed,
                             averageSpeed: drivingStats.averageSpeed,
                             date: formattedDate)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("scores")
            .document(newId)
            .setData(newScore.asDictionary())
    }
}
