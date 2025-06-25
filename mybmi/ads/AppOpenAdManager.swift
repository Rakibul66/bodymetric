//
//  AppOpenAdManager.swift
//  mybmi
//
//  Created by Roxy  on 25/6/25.
//


import GoogleMobileAds
import Foundation

@MainActor
class AppOpenAdManager: NSObject {
    static let shared = AppOpenAdManager()

    private var appOpenAd: AppOpenAd?
    private var isLoadingAd: Bool = false
    private var isShowingAd: Bool = false

    private let adUnitID = "ca-app-pub-3940256099942544/5575463023" // Test App Open Ad ID

    // MARK: - Load App Open Ad
    func loadAd() async {
        // Don’t load if already loading or ad is ready
        guard !isLoadingAd && !isAdAvailable() else { return }

        isLoadingAd = true
        do {
            let request = Request()
            appOpenAd = try await AppOpenAd.load(with: adUnitID, request: request)
            print("✅ App open ad loaded")
        } catch {
            print("❌ Failed to load app open ad: \(error.localizedDescription)")
        }
        isLoadingAd = false
    }

    // MARK: - Show App Open Ad if Ready
    func showAdIfAvailable() {
        // Don't show if already showing
        guard !isShowingAd else { return }

        // Try loading if not available
        guard isAdAvailable() else {
            Task { await loadAd() }
            return
        }

        if let ad = appOpenAd {
            isShowingAd = true
            ad.present(from: nil)
            print("📣 Presenting app open ad")

            // Optional: hook into delegate callbacks if needed
            // No reload here – you should trigger loadAd() again when appropriate (e.g. onDismiss)
        }
    }

    // MARK: - Ad Available Check
    private func isAdAvailable() -> Bool {
        return appOpenAd != nil
    }
}
