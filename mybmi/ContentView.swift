import SwiftUI

struct ContentView: View {
    @State private var selectedWeight: Int = 70  // Default weight in kg
    @State private var selectedHeight: Double = 1.75  // Default height in meters
    @State private var bmiResult: String = "Your BMI will appear here"
    @State private var isLoading: Bool = false
    
    let bmiService = BMIService()

    // Range of selectable weights and heights
    let weightRange = Array(30...200)  // 30 kg to 200 kg
    let heightRange = stride(from: 1.0, to: 2.5, by: 0.01).map { Double($0) }  // 1.0 m to 2.5 m in steps of 0.01 m

    var body: some View {
        ZStack {
            Color(hex: "FFFFFF")  // Body background color
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("BMI Calculator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "65B741"))

                // Weight Picker
                VStack {
                    Text("Select Weight (kg)")
                        .font(.headline)
                        .foregroundColor(Color(hex: "65B741"))
                    
                    Picker("Weight", selection: $selectedWeight) {
                        ForEach(weightRange, id: \.self) { weight in
                            Text("\(weight) kg").tag(weight)
                        }
                    }
                    .pickerStyle(platformSpecificPickerStyle())
                    .frame(height: pickerHeight())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }

                // Height Picker
                VStack {
                    Text("Select Height (m)")
                        .font(.headline)
                        .foregroundColor(Color(hex: "65B741"))
                    
                    Picker("Height", selection: $selectedHeight) {
                        ForEach(heightRange, id: \.self) { height in
                            Text(String(format: "%.2f m", height)).tag(height)
                        }
                    }
                    .pickerStyle(platformSpecificPickerStyle())
                    .frame(height: pickerHeight())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }

                // Button to calculate BMI
                Button(action: calculateBMI) {
                    Text("Calculate BMI")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "65B741"))
                        .cornerRadius(10)
                }
                .disabled(isLoading)  // Disable button while loading

                // Display the BMI result
                if isLoading {
                    ProgressView()  // Horizontal loader
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                } else {
                    resultCard
                }

                Spacer()
            }
            .padding()
        }
    }

    // Result card view
    private var resultCard: some View {
        VStack {
            Text(bmiResult)
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "519234"))
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .transition(.slide)  // Animation for result
        }
        .padding()
        .animation(.easeInOut, value: bmiResult)  // Animate result changes
    }

    // Method to calculate BMI using the API
    func calculateBMI() {
        isLoading = true  // Start loading
        let weightValue = Double(selectedWeight)
        let heightValue = selectedHeight

        bmiService.fetchBMI(weight: weightValue, height: heightValue) { result in
            DispatchQueue.main.async {
                isLoading = false  // Stop loading
                switch result {
                case .success(let bmiResponse):
                    bmiResult = "Your BMI: \(String(format: "%.2f", bmiResponse.bmi))"
                case .failure(let error):
                    bmiResult = "Error calculating BMI: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Platform-specific picker style
    private func platformSpecificPickerStyle() -> some PickerStyle {
        #if os(macOS)
        return MenuPickerStyle()
        #else
        return WheelPickerStyle()
        #endif
    }
    
    // Platform-specific picker height
    private func pickerHeight() -> CGFloat {
        #if os(macOS)
        return 40
        #else
        return 150
        #endif
    }
}

// Extension for hex color
extension Color {
    init?(hex: String) {
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)  // Correct method name
        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }
}

#Preview {
    ContentView()
}
