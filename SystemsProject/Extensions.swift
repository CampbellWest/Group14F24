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
