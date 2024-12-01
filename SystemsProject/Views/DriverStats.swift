//
//  DriverStats.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-29.
//

import SwiftUI
import Foundation

struct DriverStats: View {
    
    let driverStats: Stats
    
    var body: some View {
        VStack {
            
                VStack {
                    HStack {
                        Text("\(driverStats.date.changeDate())")
                            .padding(CGFloat.leastNormalMagnitude)
                            .font(.system(size: 20, weight: .medium, design: .monospaced))
                            .padding(.horizontal)
                        Spacer()
                        Text("\(driverStats.score)%")
                            .font(.system(size: 25, weight: .medium, design: .monospaced))
                            .padding(.horizontal)
                    }
                    HStack {
                        Text("Speeds")
                            .padding(CGFloat.leastNormalMagnitude)
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                            .padding(.horizontal)
                        Spacer()
                    }
                    VStack {
                        HStack {
                            Text("Top: \(driverStats.maxSpeed.roundToTwo())km")
                                .padding(CGFloat.leastNormalMagnitude)
                                .font(.system(size: 15, weight: .medium, design: .monospaced))
                                .padding(.horizontal)
                            Spacer()
                        }
                        HStack {
                            Text("Average: \(driverStats.averageSpeed.roundToTwo())km")
                                .padding(CGFloat.leastNormalMagnitude)
                                .font(.system(size: 15, weight: .medium, design: .monospaced))
                                .padding(.horizontal)
                            Spacer()
                        }
                    }
                }
            //.frame(height: 175) // Dynamically adjust height if needed
            //.scrollContentBackground(.hidden)
        }
    }
}



#Preview {
    DriverStats(driverStats: Stats(score: 0, maxSpeed: 0.0, averageSpeed: 0.0, date: "abc"))
}
