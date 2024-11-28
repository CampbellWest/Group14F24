//
//  MainView.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-05.
//

import SwiftUI
import CoreLocation

struct DrivingStats {
    var score: Int
    var maxSpeed: Double
    var averageSpeed: Double
}

struct MainAppView: View {
    @StateObject var viewModel = MainViewModel()
        
        var body: some View {
            
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                //signed in / main screen
                AppView()
                
            } else {
                LoginView()
            }
        }
}

struct AppView: View {

    @State private var currentView: ContentView = .main
    @State private var drivingStats = DrivingStats(score: 0, maxSpeed: 0.0, averageSpeed: 0.0)
        
    var body: some View {
        NavigationView {
            
            VStack {
                switch currentView {
                case .main:
                    MainView(currentView: $currentView)
                case .driving:
                    DrivingView(currentView: $currentView, drivingStats: $drivingStats)
                case .score:
                    ScoreView(currentView: $currentView, drivingStats: $drivingStats)
                case .loading:
                    LoadingView(currentView: $currentView)
                }
            }
            .padding(.top, -30)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserView()) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("App Name")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                }
            }
        }
    }
}

enum ContentView {
    case main
    case driving
    case score
    case loading
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
            .padding(.top, -75)
        }
    }
}

struct LoadingView: View {
    @Binding var currentView: ContentView
    var body: some View {
        CircleButton(title: "Analyzing...")
            .padding(.top, -75)
    }
}

struct DrivingView: View {
    
    @Binding var currentView: ContentView
    @Binding var drivingStats: DrivingStats
    
    @StateObject private var locationManager = LocationManager()
    
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Button {
                
                isLoading = true
                currentView = .loading
                
                Task {
                    do {
                        try await updateDrivingStats(drivingStats: $drivingStats, locationManager: locationManager)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            // Transition to the score view after 2.5 seconds
                            isLoading = false
                            currentView = .score
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
                
            } label: {
                CircleButton(title: "End Drive")
            }
            .padding(.top, -75)
            
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

@MainActor
func updateDrivingStats(drivingStats: Binding<DrivingStats>, locationManager: LocationManager) async throws {
    do {
        if let newDrivingStats = try await locationManager.stopTrackingSpeed() {
            drivingStats.wrappedValue = DrivingStats(score: newDrivingStats.score, maxSpeed: newDrivingStats.maxSpeed, averageSpeed: newDrivingStats.averageSpeed)
        } else {
            print("Error stopping tracking speed")
        }
    } catch {
        print("Error updating driving stats: \(error)")
    }
}

struct ScoreView: View {
    
    @Binding var currentView: ContentView
    @Binding var drivingStats: DrivingStats
    
    @StateObject var databaseModel = Database()
    
    var body: some View {
        VStack{
            Button {
                databaseModel.saveScore(drivingStats: drivingStats)
                currentView = .main
            } label: {
                CircleButton(title: "\(drivingStats.score)%")
            }
            .padding(.top, -75)
        }
    }
}

#Preview {
    AppView()
}
