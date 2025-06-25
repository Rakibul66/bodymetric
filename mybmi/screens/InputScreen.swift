import SwiftUI

struct InputScreen: View {
    var selectedGender: String

    @State private var weight: Int = 70
    @State private var heightCm: Double = 175
    @State private var heightFeet: Int = 5
    @State private var heightInches: Int = 9
    @State private var isCmSelected = true
    @State private var age: Int = 25
    @State private var activityLevel: String = "Sedentary"
    @State private var navigateToResult = false
    @State private var bmiResult: BMIRecord?

    @AppStorage("bmiHistory") private var historyData: Data = Data()
    @State private var history: [BMIRecord] = []

    let activityLevels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active"]

    var body: some View {
        ZStack {
            Color(hex: "080E23").edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 20) {
                Text("Enter Your Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)

                // **Weight Picker**
                VStack(alignment: .leading, spacing: 5) {
                    Text("Weight (kg)").font(.headline).foregroundColor(.green)
                    Picker("Weight", selection: $weight) {
                        ForEach(30...200, id: \.self) { w in
                            Text("\(w) kg").tag(w)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 120)
                    .background(Color(hex: "142B4A"))
                    .cornerRadius(10)
                }

                // **Height Picker**
                VStack(alignment: .leading, spacing: 5) {
                    Text("Height").font(.headline).foregroundColor(.green)
                    Picker("Height Unit", selection: $isCmSelected) {
                        Text("cm").tag(true)
                        Text("ft/in").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(hex: "142B4A"))
                    .cornerRadius(10)

                    if isCmSelected {
                        Stepper(value: $heightCm, in: 100...250, step: 1) {
                            Text("\(Int(heightCm)) cm").foregroundColor(.white)
                        }
                    } else {
                        HStack {
                            Picker("Feet", selection: $heightFeet) {
                                ForEach(3...8, id: \.self) { Text("\($0) ft").tag($0) }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80)

                            Picker("Inches", selection: $heightInches) {
                                ForEach(0...11, id: \.self) { Text("\($0) in").tag($0) }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80)
                        }
                    }
                }

                // **Age Picker**
                VStack(alignment: .leading, spacing: 5) {
                    Text("Age").font(.headline).foregroundColor(.green)
                    HStack {
                        Button(action: { if age > 10 { age -= 1 } }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                        
                        Text("\(age) years")
                            .foregroundColor(.white)
                            .frame(minWidth: 50)
                        
                        Button(action: { if age < 100 { age += 1 } }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                    }
                }

                // **Activity Level Picker**
                VStack(alignment: .leading, spacing: 5) {
                    Text("Activity Level").font(.headline).foregroundColor(.green)
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(activityLevels, id: \.self) { level in
                            Text(level).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color(hex: "142B4A"))
                    .cornerRadius(10)
                }

                // **Calculate Button**
                Button(action: calculateBMI) {
                    Text("Calculate BMI")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 20)

                NavigationLink(destination: ResultView(bmiRecord: bmiResult), isActive: $navigateToResult) {
                    EmptyView()
                }
            }
            .padding()
        }
        .onAppear(perform: loadHistory) // Load history when screen appears
    }

    func calculateBMI() {
        let heightInMeters = isCmSelected ? heightCm / 100 : (Double(heightFeet) * 0.3048) + (Double(heightInches) * 0.0254)
        let bmiValue = Double(weight) / (heightInMeters * heightInMeters)
        let category = getBMICategory(for: bmiValue)

        let newRecord = BMIRecord(
            gender: selectedGender, weight: weight, height: heightInMeters,
            age: age, activityLevel: activityLevel, bmi: bmiValue,
            category: category, date: Date()
        )

        bmiResult = newRecord
        saveToHistory(newRecord)

        withAnimation {
            navigateToResult = true
        }
    }

    func saveToHistory(_ record: BMIRecord) {
        loadHistory()  // Ensure existing history is loaded first
        history.append(record)
        if let encoded = try? JSONEncoder().encode(history) {
            historyData = encoded
        }
    }

    func loadHistory() {
        if let decoded = try? JSONDecoder().decode([BMIRecord].self, from: historyData) {
            history = decoded
        }
    }

    func getBMICategory(for bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        case 30..<35: return "Obese Class I"
        case 35..<40: return "Obese Class II"
        default: return "Obese Class III"
        }
    }
}
