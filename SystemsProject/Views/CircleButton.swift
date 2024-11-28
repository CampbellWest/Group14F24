//
//  CircleButton.swift
//  SystemsProject
//
//  Created by Campbell West on 2024-11-05.
//

import SwiftUI

struct CircleButton: View {
    
    let title: String
    
    var body: some View {
    
        ZStack{
            Circle()
                .frame(width: 300)
                .foregroundColor(Color.black)
            
            Circle()
                .frame(width: 290)
                .foregroundColor(Color.white)
            
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .shadow(radius: 1)
                //.font(.largeTitle)
                //.foregroundColor(Color.black)
                //.shadow(radius: 5)
                //.opacity(0.8)
        }
        .shadow(radius: 10)
    }
    
}

#Preview {
    CircleButton(title: "Start Drive")
}
