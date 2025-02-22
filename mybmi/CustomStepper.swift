//
//  CustomStepper.swift
//  mybmi
//
//  Created by Roxy  on 20/2/25.
//


import SwiftUI

struct CustomStepper: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.green)
            
            HStack {
                // **Decrement Button (-)**
                Button(action: {
                    if value > range.lowerBound { value -= 1 }
                }) {
                    Text("-")
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                // **Value Display**
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 60, height: 40)
                    .background(Color(hex: "142B4A"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                // **Increment Button (+)**
                Button(action: {
                    if value < range.upperBound { value += 1 }
                }) {
                    Text("+")
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}
