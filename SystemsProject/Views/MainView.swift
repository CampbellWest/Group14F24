//
//  MainView.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-05.
//

import SwiftUI
import CoreLocation

struct AppView: View {

    @State private var currentView: ContentView = .main
    @State private var tempSpeed: Double = 0.0
        
    var body: some View {
        NavigationView {
            
            VStack {
                switch currentView {
                case .main:
                    MainView(currentView: $currentView)
                case .driving:
                    DrivingView(currentView: $currentView, tempSpeed: $tempSpeed)
                case .score:
                    ScoreView(currentView: $currentView, tempSpeed: $tempSpeed)
                }
            }
            .padding(.top, -30)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserView()) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            //.padding(.top, 40)
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("App Name")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        //.padding(.top, 40)
                }
            }
        }
    }
}

enum ContentView {
    case main
    case driving
    case score
}

struct MainView: View {
    @Binding var currentView: ContentView
    
    var body: some View {
        VStack {
            Button {
                currentView = .driving
            } label: {
                CircleButton(title: "Start Drive")
            }
            
            /*VStack {
                Text("Did You Know?")
                    .font(.headline)
                Text("Blah blah blah") // Convert m/s to km/h
                    
                 */
        }
        //.padding(.top, 10)
    }
}


struct DrivingView: View {
    
    @Binding var currentView: ContentView
    @Binding var tempSpeed: Double
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            
            Button {
                tempSpeed = locationManager.stopTrackingSpeed()
                
                print(tempSpeed)
                
                currentView = .score
            } label: {
                CircleButton(title: "End Drive")
            }
            
            VStack {
                Text("Current Speed")
                    .font(.headline)
                
                Text("\(locationManager.speed * 3.6, specifier: "%.2f") km/h") // Convert m/s to km/h
                    .font(.largeTitle)
                    .padding()
            }
            .padding(.top, 50)
        }
        
        .padding(.top, 175)
    }
}

struct ScoreView: View {
    
    @Binding var currentView: ContentView
    
    @Binding var tempSpeed: Double
    
    var body: some View {
        Button {
            currentView = .main
        } label: {
            CircleButton(title: "\(tempSpeed.roundToTwo()) km/h")
        }
    }
}

#Preview {
    AppView()
}
