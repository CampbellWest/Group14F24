//
//  User.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserModel: ObservableObject {
    
    @Published var driverStats: [Stats] = []
    
    init(){}
    
    @Published var user: User? = nil
    
    func getUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.user = User(id: data["id"] as? String ?? "", email: data["email"] as? String ?? "", name: data["name"] as? String ?? "")
            }
        }
    }
    
    func getData() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        let snapshot = try await db.collection("users")
                                   .document(userId)
                                   .collection("scores")
                                   .getDocuments()
        
        for document in snapshot.documents {
            let data = document.data()
            let newDriverStats = Stats(score: data["score"] as! Int,
                                    maxSpeed: data["maxSpeed"] as! Double,
                                    averageSpeed: data["averageSpeed"] as! Double,
                                    date: data["date"] as! String)
            
            driverStats.append(newDriverStats)
            if driverStats.count == 10 {
                return
            }
        }
    }
    
    // retrieve last 10 drives into an array
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

