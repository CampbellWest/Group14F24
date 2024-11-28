//
//  RegisterView.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-10-30.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("First Name", text: $viewModel.name)
                    TextField("Email", text: $viewModel.email)
                    TextField("Password", text: $viewModel.password)
                    
                    Button {
                        viewModel.register()
                    } label: {
                        Text("Register")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("App Name")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                    
                }
            }
        }
    }
}

#Preview {
    RegisterView()
}
