//
//  InterstitialViewModel.swift
//  mybmi
//
//  Created by Roxy  on 25/6/25.
//


import GoogleMobileAds
import SwiftUI

@MainActor
class InterstitialViewModel: NSObject, ObservableObject, FullScreenContentDelegate {
    private var interstitialAd: InterstitialAd?

    override init() {
        super.init()
        Task {
            await loadAd()
        }
    }

    func loadAd() async {
        do {
            let request = Request()
            interstitialAd = try await InterstitialAd.load(
                with: "ca-app-pub-3940256099942544/4411468910", // 🔁 Replace with your real AdUnit ID
                request: request
            )
            interstitialAd?.fullScreenContentDelegate = self
            print("✅ Interstitial ad loaded")
        } catch {
            print("❌ Failed to load interstitial ad: \(error.localizedDescription)")
        }
    }

    func showAd(from rootViewController: UIViewController?) {
        guard let interstitialAd = interstitialAd else {
            print("⚠️ Ad wasn't ready.")
            return
        }

        interstitialAd.present(from: rootViewController)
        self.interstitialAd = nil // Reset
        Task { await loadAd() } // Preload next
    }

  
}
