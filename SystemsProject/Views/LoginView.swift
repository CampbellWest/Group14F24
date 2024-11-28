//
//  LoginView.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-10-30.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    TextField("Login", text: $viewModel.email)
                    TextField("Password", text: $viewModel.password)
                    Button {
                        viewModel.login()
                    } label: {
                        Text("Login")
                    }
                }
                
            
                VStack {
                    Text("No Account?")
                    NavigationLink("Create An Account"){
                        RegisterView()
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
    LoginView()
}
