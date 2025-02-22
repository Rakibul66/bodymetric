import SwiftUI

struct HistoryView: View {
    @AppStorage("bmiHistory") private var historyData: Data = Data()
    @State private var history: [BMIRecord] = []

    var body: some View {
        ZStack {
            Color(hex: "080E23").edgesIgnoringSafeArea(.all)

            VStack {
                Text("BMI History")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                if history.isEmpty {
                    Text("No history available").foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) { // Adjust spacing for a cleaner look
                            ForEach(history) { record in
                                historyCard(record: record)
                            }
                        }
                        .padding(.horizontal, 16) // Add padding for better alignment
                    }
                }

                // **Clear History Button**
                if !history.isEmpty {
                    Button(action: clearHistory) {
                        Text("Clear History")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: loadHistory)
    }

    func loadHistory() {
        if let decoded = try? JSONDecoder().decode([BMIRecord].self, from: historyData) {
            history = decoded
        }
    }

    func clearHistory() {
        history = []
        historyData = Data() // Reset UserDefaults
    }
}

// **📌 Full-Width History Card UI**
func historyCard(record: BMIRecord) -> some View {
    VStack(alignment: .leading, spacing: 8) { // More spacing for better readability
        Text("BMI: \(String(format: "%.1f", record.bmi))")
            .font(.headline)
            .foregroundColor(.white)
        
        Text("Weight: \(record.weight) kg, Height: \(String(format: "%.2f", record.height)) m")
            .font(.subheadline)
            .foregroundColor(.white)
        
        Text("Category: \(record.category)")
            .foregroundColor(getColor(for: record.bmi))
            .font(.subheadline)
            .fontWeight(.semibold)

        Text("Date: \(record.date, formatter: dateFormatter)")
            .font(.caption)
            .foregroundColor(.gray)
    }
    .padding()
    .frame(maxWidth: .infinity) // 🔥 Makes the card full width
    .background(Color(hex: "142B4A"))
    .cornerRadius(12) // Slightly increased corner radius for a modern look
    .padding(.horizontal, 0) // Ensures the card reaches the screen edges
}

// **Color Function Based on BMI**
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

// **Date Formatter**
var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}
