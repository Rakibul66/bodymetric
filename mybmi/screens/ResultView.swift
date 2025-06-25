import SwiftUI
import GoogleMobileAds

struct ResultView: View {
    let bmiRecord: BMIRecord?
    
    @State private var animateGauge = false
    @State private var showDetails = false
    @Environment(\.presentationMode) var presentationMode
    @State private var screenshotImage: UIImage?
    @State private var showShareSheet = false
    @StateObject var adModel = InterstitialViewModel() // ✅ Add this

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: "080E23").edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    if let record = bmiRecord {
                        ScrollView {
                            VStack(spacing: 20) {
                                // Gauge
                                ZStack {
                                    GaugeView(bmi: record.bmi, animate: $animateGauge)
                                        .frame(height: 200)

                                    Text(String(format: "%.1f", record.bmi))
                                        .font(.system(size: 55, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .offset(y: 60)
                                        .scaleEffect(animateGauge ? 1 : 0.8)
                                        .animation(.easeInOut(duration: 1.2), value: animateGauge)
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        animateGauge = true
                                        showDetails = true
                                    }
                                }

                                // Info Rows
                                VStack(spacing: 15) {
                                    infoRow(label: "Category", value: record.category)
                                    infoRow(label: "Weight", value: "\(record.weight) kg")
                                    infoRow(label: "Height", value: String(format: "%.2f m", record.height))
                                    infoRow(label: "Age", value: "\(record.age)")
                                    infoRow(label: "Activity Level", value: record.activityLevel)
                                }
                                .padding()
                                .background(BlurView(style: .systemUltraThinMaterialDark))
                                .cornerRadius(15)
                                .opacity(showDetails ? 1 : 0)
                                .offset(y: showDetails ? 0 : 30)
                                .animation(.easeOut(duration: 1), value: showDetails)

                                // Buttons
                                HStack(spacing: 20) {
                                    actionButton(title: "Share", icon: "square.and.arrow.up", color: .blue) {
                                        shareResult()
                                        if let rootVC = UIApplication.shared.connectedScenes
                                            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController }).first {
                                            adModel.showAd(from: rootVC)
                                        }
                                    }

                                    actionButton(title: "Home", icon: "house.fill", color: .green) {
                                        if let rootVC = UIApplication.shared.connectedScenes
                                            .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController }).first {
                                            adModel.showAd(from: rootVC)
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }

                                .opacity(showDetails ? 1 : 0)
                                .animation(.easeInOut(duration: 1.2), value: showDetails)

                                Spacer().frame(height: 60) // Padding for Ad
                            }
                            .padding()
                        }

                        // Fixed Bottom Ad
                        AdBannerView()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.black.opacity(0.05))
                    }
                }
            }
        }
    }

    @ViewBuilder
    func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label).foregroundColor(.green).font(.headline)
            Spacer()
            Text(value).foregroundColor(.white).fontWeight(.semibold)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .offset(y: showDetails ? 0 : 15)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showDetails)
    }

    @ViewBuilder
    func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color.gradient)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(showDetails ? 1 : 0.8)
            .animation(.spring(), value: showDetails)
        }
    }

    func shareResult() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        UIGraphicsBeginImageContextWithOptions(window?.bounds.size ?? CGSize(width: 300, height: 500), false, 0)
        window?.drawHierarchy(in: window?.bounds ?? CGRect.zero, afterScreenUpdates: true)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = screenshotImage {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            if let rootVC = window?.rootViewController {
                rootVC.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}


// **Modern Gauge Chart with Animated BMI Meter**
struct GaugeView: View {
    let bmi: Double
    @Binding var animate: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // **Multi-Colored BMI Arc**
                ForEach(0..<6) { index in
                    let startAngle = CGFloat(index) * 36 - 90
                    let endAngle = startAngle + 36
                    
                    ArcShape(startAngle: Angle(degrees: startAngle),
                             endAngle: Angle(degrees: endAngle))
                        .stroke(getGradient(for: index), lineWidth: 20)
                        .frame(width: geo.size.width, height: geo.size.width)
                        .opacity(animate ? 1 : 0.5)
                        .animation(.easeInOut(duration: 1), value: animate)
                }
                
                // **BMI Meter Needle with Rotation Animation**
                let angle = CGFloat((bmi / 40) * 180 - 90)
                Capsule()
                    .fill(Color.white)
                    .frame(width: 6, height: 35)
                    .offset(y: -geo.size.width / 2)
                    .rotationEffect(animate ? Angle(degrees: angle) : Angle(degrees: -90))
                    .animation(.easeInOut(duration: 1.2), value: animate)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    // **Color Gradients for Each BMI Range**
    func getGradient(for index: Int) -> LinearGradient {
        let colors: [Color] = [
            .blue, .green, .yellow, .orange, .red, .purple
        ]
        return LinearGradient(gradient: Gradient(colors: [colors[index], colors[index].opacity(0.6)]),
                              startPoint: .top, endPoint: .bottom)
    }
}

// **Arc Shape for BMI Gauge**
struct ArcShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path
    }
}

// **Glassmorphic Background for Table**
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
