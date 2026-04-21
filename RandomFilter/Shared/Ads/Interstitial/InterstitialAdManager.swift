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
                with: "ca-app-pub-3940256099942544/4411468910",
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
            
            guard let rootVC = Self.topViewController() else {
                onDismiss()
                return
            }
            
            self.onDismiss = onDismiss
            ad.fullScreenContentDelegate = self
            ad.present(from: rootVC)
        }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitialAd = nil
        onDismiss?()
        Task { await load() } // preload lại
    }
    

}

extension InterstitialAdManager {
    static func topViewController(
        base: UIViewController? = UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    ) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
