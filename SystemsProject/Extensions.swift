//
//  Extensions.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-10-30.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

extension Double {
    func roundToTwo() -> String {
        return String(format: "%.2f", self)
    }
}

extension String {
    func changeDate() -> String {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd, h:mm:ss a" // Input format, including seconds

        if let date = inputFormatter.date(from: self) {
        
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd, h:mm a" // Output without seconds 
            
            let outputString = outputFormatter.string(from: date)
            return outputString
        } else {
            print("Invalid date format")
        }
        return ""
    }
}
