//
//  UserView.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-05.
//
/*
 struct Stats: Codable {
     let score: Int
     let maxSpeed: Double
     let averageSpeed: Double
     let date: String
 }
 */

import SwiftUI

struct UserView: View {
    
    @StateObject var viewModel = UserModel()
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Text("Hello, \(viewModel.user?.name ?? "")!")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    Spacer()
                }
                
                Text("Most Recent Trip")
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                
                Text("Last 10 Trips")
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                
                ScrollView {
                    ForEach(viewModel.driverStats, id: \.self) { stat in
                        Text("\(stat.score)")
                    }
                    
                    /*               if let user = viewModel.user {
                     Text(user.email)
                     Button {
                     viewModel.signOut()
                     } label: {
                     Text("Log Out")
                     }
                     } else {
                     Text("Loading Profile...")
                     }
                     */
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
                    Text("Account Settings")
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
