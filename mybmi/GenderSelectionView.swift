//
//  GenderSelectionView.swift
//  mybmi
//
//  Created by Roxy  on 20/2/25.
//


import SwiftUI

struct GenderSelectionView: View {
    @State private var selectedGender: String? = nil
    @State private var navigateToInputScreen = false

    var body: some View {
        ZStack {
            Color(hex: "080E23").edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Select Gender")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                HStack {
                    genderCard(title: "Male", image: "person.fill", selected: selectedGender == "Male")
                        .onTapGesture {
                            withAnimation {
                                selectedGender = "Male"
                                navigateToInputScreen = true
                            }
                        }
                    
                    genderCard(title: "Female", image: "person.fill", selected: selectedGender == "Female")
                        .onTapGesture {
                            withAnimation {
                                selectedGender = "Female"
                                navigateToInputScreen = true
                            }
                        }
                }
                .padding(.top, 20)
                
                NavigationLink(destination: InputScreen(selectedGender: selectedGender ?? "Male"), isActive: $navigateToInputScreen) {
                    EmptyView()
                }
            }
            .padding()
        }
    }

    func genderCard(title: String, image: String, selected: Bool) -> some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 120, height: 150)
        .background(Color(hex: "142B4A"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selected ? Color.green : Color.clear, lineWidth: 3)
                .animation(.easeInOut, value: selected)
        )
    }
}
