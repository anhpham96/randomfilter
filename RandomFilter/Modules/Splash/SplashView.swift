//
//  SplashView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 16/4/26.
//

import SwiftUI

struct SplashView: View {

    @StateObject var viewModel: SplashViewModel = SplashViewModel()
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var purchaseManager: PurchaseManager
    private let interstitialAdsManager = InterstitialAdManager()

    var body: some View {
        mainView
        .onReceive(viewModel.event, perform: handleEvent)
        .onAppear {
            
        }
        .task {
            await interstitialAdsManager.load()
            viewModel.start()
        }
    }
    
    var mainView: some View {
        GeometryReader { geometry in
            ZStack {
                Color.backgroundPrimary300
                    .ignoresSafeArea()
                VStack {
                    imagesStack(height: geometry.size.height * 0.66)
                    logoView
                    loadingTextView
                    progressBar
                    Spacer()
                }
            }
        }
    }
    
}

// MARK: - Subviews
private extension SplashView {
    func imagesStack(height: CGFloat) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
                
            ZStack {
                splashPhoto(width: width*0.48, height: height*0.42)
                ForEach(SplashDecoratorItem.items) { item in
                    SplashDecoratorItemView(item: item)
                        .offset(
                            x: item.offset.width * width,
                            y: item.offset.height * height
                        )
                    }
                    
                SplashTextItemView(text: "Random")
                        .offset(
                            x: width * 0.22,
                            y: height * -0.18
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        .background {
            SplashRandomBackgroundView()
        }
        .frame(height: height)
    }
    
    private func splashPhoto(width: CGFloat, height: CGFloat) -> some View {
        Image(.splashPhoto)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipShape(
                RoundedRectangle(cornerRadius: 40)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                .stroke(
                    Color.purplePrimary,
                    lineWidth: 7
                )
            }
            .rotationEffect(.degrees(-11.95))
    }
    
    var logoView: some View {
        Image(.titleLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 198)
    }
    
    var loadingTextView: some View {
        Text(Str.loadingTitle)
            .bold()
    }
    
    var progressBar: some View {
        ProgressBarView(progress: $viewModel.progress, duration: viewModel.duration, progressBarColor: Color.backgroundPrimary500)
    }
}


// MARK: - Actions

private extension SplashView {
    private func handleEvent(_ event: SplashEvent) {
        switch event {
        case .didFinish:
            let navigate = {
                withAnimation {
                    router.route = router.getRouteAfterSplash()
                }
            }
                
            purchaseManager.isPremium
            ? navigate()
            : interstitialAdsManager.showAd(onDismiss: navigate)
        }
    }
    
   
}


// MARK: - Constants

private extension SplashView {
    enum Str {
        static let loadingTitle = "Loading..."
    }
}

#Preview {
    SplashView()
        .environmentObject(AppRouter(purchaseManager: PurchaseManager()))
}
