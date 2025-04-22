import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack {
                    // Top bar with Back button and Centered Title
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
                        
                        // Invisible Spacer for Centered Effect
                        Image(systemName: "chevron.left")
                            .opacity(0)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    List {
                        Section {
                            SettingsRow(icon: "star.fill", title: "Rate Us", color: .blue) {
                                if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            SettingsRow(icon: "pencil", title: "Feedback", color: .blue) {
                                // Show email composer or open a feedback form
                            }
                            SettingsRow(icon: "square.and.arrow.up", title: "Share App", color: .blue) {
                                shareApp()
                            }
                        }

                        Section {
                            SettingsRow(icon: "doc.text", title: "Privacy Policy", color: .blue) {
                                openLink("https://yourapp.com/privacy")
                            }
                            SettingsRow(icon: "link", title: "Reference Links", color: .blue) {
                                openLink("https://yourapp.com/links")
                            }
                            SettingsRow(icon: "apps.iphone", title: "More Apps", color: .blue) {
                                openLink("https://apps.apple.com/developer/idYOUR_DEV_ID")
                            }
                        }

                        Section {
                            SettingsRow(icon: "trash", title: "Delete Data", color: .red) {
                                deleteAppData()
                            }
                        }
                    }

                    .listStyle(InsetGroupedListStyle())
                    .background(Color.fromHex("142B4A")) // Applied Fixed Hex Color
                    .scrollContentBackground(.hidden)
                }
                .padding(.top, 10) // Gives spacing from the top
            }
        }
        .navigationBarHidden(true) // Hide Default Navigation Bar
    }
}

// Row View Component
struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.fromHex("142B4A"))
            .cornerRadius(10)
        }
    }
}


// ✅ Fixed Color Extension for Hex
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
    }
}

func openLink(_ urlString: String) {
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}

func shareApp() {
    let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!
    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    
    // iOS 16+ workaround to present from SwiftUI
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let root = scene.windows.first?.rootViewController {
        root.present(activityVC, animated: true, completion: nil)
    }
}

func deleteAppData() {
    // Replace this with actual logic (e.g., UserDefaults.remove, CoreData deletion)
    print("🗑 All data deleted")
}
