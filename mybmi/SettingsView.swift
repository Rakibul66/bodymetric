//
//  SettingsView.swift
//  mybmi
//
//  Created by Roxy  on 20/2/25.
//

import SwiftUI
struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(hex: "080E23").edgesIgnoringSafeArea(.all)
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Text("Coming Soon!")
                    .foregroundColor(.gray)
            }
        }
    }
}
