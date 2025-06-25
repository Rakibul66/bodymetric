import SwiftUI
import GoogleMobileAds

@main
struct mybmiApp: App {
    // Initialize once when the app launches
    init() {
        // ✅ Start Google Mobile Ads SDK
        MobileAds.shared.start { status in
            print("✅ AdMob initialized: \(status.adapterStatusesByClassName)")
        }

        // ✅ Preload App Open Ad
        Task {
            await AppOpenAdManager.shared.loadAd()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    // ✅ Show app open ad on resume
                    AppOpenAdManager.shared.showAdIfAvailable()
                }
        }
    }
}
