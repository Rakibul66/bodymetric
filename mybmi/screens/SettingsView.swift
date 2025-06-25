import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingMailView = false
    @State private var showShareSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.fromHex("142B4A")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Top bar
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }

                        Spacer()

                        Text("Settings")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: "chevron.left")
                            .opacity(0)
                    }
                    .padding(.horizontal)

                    Spacer()

                    VStack(spacing: 16) {
                        Button {
                            requestAppReview()
                        } label: {
                            SettingsRow(icon: "star.fill", title: "Rate Us", color: .yellow)
                        }

                        Button {
                            openEmail()
                        } label: {
                            SettingsRow(icon: "pencil", title: "Feedback", color: .blue)
                        }

                        Button {
                            showShareSheet = true
                        } label: {
                            SettingsRow(icon: "square.and.arrow.up", title: "Share App", color: .blue)
                        }

                        Divider().background(Color.white.opacity(0.2))

                        Button {
                            openURL("https://sites.google.com/view/bodymetric88/")
                        } label: {
                            SettingsRow(icon: "doc.text", title: "Privacy Policy", color: .blue)
                        }

                        Divider().background(Color.white.opacity(0.2))

                        SettingsRow(icon: "trash", title: "Delete Data", color: .red)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.3))
                            .background(.ultraThinMaterial)
                            .blur(radius: 10)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding(.top, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: ["Check out this awesome app!"])
        }
    }

    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func openEmail() {
        let email = "roxyhasan76@gmail.com"
        let subject = "App Feedback"
        let encoded = "mailto:\(email)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: encoded ?? "") {
            UIApplication.shared.open(url)
        }
    }

    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// Share Sheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Row Component
struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18, weight: .medium))

            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .regular))

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// Color Extension
extension Color {
    static func fromHex(_ hex: String) -> Color {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHex = cleanedHex.hasPrefix("#") ? String(cleanedHex.dropFirst()) : cleanedHex

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)

        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0

        return Color(red: red, green: green, blue: blue)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
