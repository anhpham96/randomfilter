//
//  InterstitialViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//


import GoogleMobileAds

final class InterstitialAdManager: NSObject, FullScreenContentDelegate {

    private var interstitialAd: InterstitialAd?
    private var onDismiss: (() -> Void)?

    func load() async {
        do {
            interstitialAd = try await InterstitialAd.load(
                with: EnvironmentApp.interUnitID,
                request: Request()
            )
            interstitialAd?.fullScreenContentDelegate = self
        } catch {
            print("Load failed:", error)
        }
    }
    
    func showAd() {
      guard let interstitialAd = interstitialAd else {
        return print("Ad wasn't ready.")
      }

      interstitialAd.present(from: nil)
    }

    func showAd(onDismiss: @escaping () -> Void) {
        guard let ad = self.interstitialAd else {
                onDismiss()
                return
        }
            
        self.onDismiss = onDismiss
        ad.present(from: nil)
    }

    
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func ad(
      _ ad: FullScreenPresentingAd,
      didFailToPresentFullScreenContentWithError error: Error
    ) {
      print("\(#function) called")
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitialAd = nil
        onDismiss?()
    }

}
