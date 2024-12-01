//
//  UserView.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-05.
//

import SwiftUI

struct UserView: View {
    
    @StateObject var viewModel = UserModel()
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View {
        NavigationView {
            let sortedDriverStats = viewModel.driverStats.sorted { $0.date > $1.date }
            VStack {
                HStack{
                    Text("Hello, \(viewModel.user?.name ?? "User")!")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    Spacer()
                }
            
                HStack {
                    VStack {
                        Text("Most Recent Trip")
                            .font(.system(size: 20, weight: .medium, design: .monospaced))
                            .padding(.horizontal)
                        
                        if viewModel.driverStats.isEmpty {
                            Text("No Recent Trips")
                        } else {
                            DriverStats(driverStats: sortedDriverStats.first!)
                        }
                    }
                    Spacer()
                }
                Divider()
                    .hidden()
                HStack {
                    VStack {
                        Text("Last 10 Trips")
                            .font(.system(size: 20, weight: .medium, design: .monospaced))
                            .padding(.horizontal)
                        
                        let sortedDriverStats = viewModel.driverStats.sorted { $0.date > $1.date }
                        ScrollView {
                            ForEach(sortedDriverStats, id: \.self) { stat in
                                Divider()
                                DriverStats(driverStats: stat)
                            }
                        }
                    }
                    Spacer()
                }
                
                ConfirmLogOutButton
            }
            .onAppear {
                viewModel.getUser()
                Task {
                    try await viewModel.getData()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Account")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                }
            }
        }
    }
    
    var ConfirmLogOutButton: some View {
      Button("Log Out", role: .destructive) {
        isPresentingConfirm = true
      }
     .confirmationDialog("Are you sure?",
       isPresented: $isPresentingConfirm) {
       Button("Log Out", role: .destructive) {
           viewModel.signOut()
        }
      }
    }
}

#Preview {
    UserView()
}
