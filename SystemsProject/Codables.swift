//
//  User.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-10-30.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let name: String
}

struct Stats: Codable, Hashable {
    let score: Int
    let maxSpeed: Double
    let averageSpeed: Double
    let date: String
}
