import SwiftUI

struct ContentView: View {
    @State private var navigateToGenderSelection = false
    @State private var navigateToHistory = false
    @State private var navigateToSettings = false
    @AppStorage("bmiHistory") private var historyData: Data = Data()
    @State private var history: [BMIRecord] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "080E23").edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    
                    // **Top Bar with App Name and Icons**
                    HStack {
                        Text("BodyMetric")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()

                        Button(action: { navigateToHistory = true }) {
                            Image(systemName: "clock.fill") // History Icon
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 10)

                        Button(action: { navigateToSettings = true }) {
                            Image(systemName: "gearshape.fill") // Settings Icon
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)

                    // **Banner Image**
                    Image("image") // Replace with actual banner image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(15)
                        .padding(.horizontal)

                    // **Recent BMI History**
                    VStack(alignment: .leading) {
                        Text("Recent History")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.leading)

                        if history.isEmpty {
                            Text("No records yet")
                                .foregroundColor(.gray)
                                .padding(.leading)
                        } else {
                            ForEach(history.prefix(2), id: \.id) { record in
                                historyCard(record: record)
                            }
                        }
                    }

                    // **Calculate BMI Button**
                    VStack {
                        Text("Want to Calculate?")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 10)

                        Button(action: { navigateToGenderSelection = true }) {
                            HStack {
                                Text("Calculate Here")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color(hex: "142B4A"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                .onAppear(perform: loadHistory) // Load real history when the screen appears

                // **Navigation Links**
                NavigationLink(destination: GenderSelectionView(), isActive: $navigateToGenderSelection) { EmptyView() }
                NavigationLink(destination: HistoryView(), isActive: $navigateToHistory) { EmptyView() }
                NavigationLink(destination: SettingsView(), isActive: $navigateToSettings) { EmptyView() }
            }
        }
    }

    // **Load Real BMI History from UserDefaults**
    func loadHistory() {
        if let decoded = try? JSONDecoder().decode([BMIRecord].self, from: historyData) {
            // Sort history by latest date first
            history = decoded.sorted(by: { $0.date > $1.date })
        }
    }

    // **History Card View**
    func historyCard(record: BMIRecord) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("BMI: \(String(format: "%.1f", record.bmi))")
                .font(.headline)
                .foregroundColor(.white)
            Text("Weight: \(record.weight) kg, Height: \(String(format: "%.2f", record.height)) m")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("Category: \(record.category)")
                .foregroundColor(getColor(for: record.bmi))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "142B4A"))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    // **Get Category Color**
    func getColor(for bmi: Double) -> Color {
        switch bmi {
        case ..<18.5: return .blue
        case 18.5..<25: return .green
        case 25..<30: return .yellow
        case 30..<35: return .purple
        case 35..<40: return .red
        default: return .orange
        }
    }
}
