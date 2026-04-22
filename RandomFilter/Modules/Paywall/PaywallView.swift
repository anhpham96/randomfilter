//
//  PaywallView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//


import SwiftUI

struct PaywallView: View {

    @StateObject var viewModel: PaywallViewModel = PaywallViewModel()
    
    @EnvironmentObject var appRouter: AppRouter
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var onClose: Completion
    
    var body: some View {
        content
            .task {
                await viewModel.setupPackages(purchaseManager: purchaseManager)
            }
            .onReceive(viewModel.event, perform: handleEvent)
    }
    
    var content: some View {
        VStack {
            VStack(spacing: 0) {
                headerView
                titleView
                packageStack
                benefitsView
            }
            .background(.white)
            .topAlignment()
            .verticalScroll()

            Spacer()
            continueButton
            supportActionsStack
        }
        .ignoresSafeArea(edges: .top)
    }
    
}

extension PaywallView {
    var headerView: some View {
        headerImageView
            .overlay(content: {
                closeButton
                    .leadingAlignment()
                    .topAlignment()
                    .padding(.horizontal, 25)
                    .padding(.vertical, 40)
            })
    }
    
    var headerImageView: some View {
        Image(.paywallHeader)
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fit)
    }
    
    var closeButton: some View {
        Button {
            viewModel.onTapClose()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.4))
                )
        }
    }
    
    var titleView: some View {
        Text(Str.title)
            .font(.racingSansOne(28))
        
    }
}

// MARK: - Constants

private extension PaywallView {
    enum Str {
        static let title = "Random Filter Premium"
        static let privacyPolicyText = "Privacy Policy"
        static let termOfUseText = "Terms Of Use"
        static let restore = "Restore"
        static let continueText = "Continue"

    }
}

extension PaywallView {
    
    var benefitsView: some View {
        PaywallBenefitBoxView()
    }
    
    var packageStack: some View {
        HStack(alignment:.bottom, spacing: 10) {
            ForEach(viewModel.packageItems) { item in
                PaywallPackageItemView(item: item, selectedItem: viewModel.selectedItem)
                    .onTapGesture {
                        viewModel.onTapPackageItem(item: item)
                    }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        
    }
    
}

private extension PaywallView {
    var supportActionsStack: some View {
        HStack {
            Link(Str.privacyPolicyText, destination: URL(string: "https://yourapp.com/privacy")!)
                .underline()
            Spacer()
            Button(Str.restore) {
                viewModel.onTapClose()
            }.bold()
            Spacer()
            Link(Str.termOfUseText, destination: URL(string: "https://yourapp.com/privacy")!)
                .underline()
        }
        .foregroundColor(.black)
        .padding(.horizontal, 25)
    }
}

private extension PaywallView {
    var continueButton: some View {
        Button(Str.continueText) {
            viewModel.onTapContinue(purchaseManager: purchaseManager)
        }.buttonStyle(.paywall(isLoading: viewModel.isLoading))
        .padding(.horizontal, 20)
        .padding(.vertical, 5)

    }
}


private extension PaywallView {
    private func handleEvent(_ event: PaywallEvent) {
        switch event {
        case .close:
            onClose()
        
        case .purchaseFailed:
            print("purchaseFailed")
        case .openRestore:
            print("openRestore")

        }
    }
    
   
}


#Preview {
    PaywallView(onClose: {
        
    })
    .environmentObject(PurchaseManager())
}
