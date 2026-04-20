//
//  PaywallViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import Foundation
import Combine

class PaywallViewModel: BaseViewModel {
    
    @Published var packageItems: [PaywallPackageItem] = []
    @Published var selectedItem: PaywallPackageItem?

    let event = PassthroughSubject<PaywallEvent, Never>()
    
    var defaultId: String = "filtercamera.premium.weekly"
    
    override init() {
        
    }
    
    func setupPackages(purchaseManager: PurchaseManager) async {
        let items = purchaseManager.getPackages()
        
        await MainActor.run {
            self.packageItems = items
            self.selectedItem = items.first(where: { $0.id == defaultId })
        }
    }
    
    func onTapClose() {
        event.send(.close)
    }
    
    func onTapRestore() {
        event.send(.openRestore)
    }
    
    func onTapPackageItem(item: PaywallPackageItem) {
        selectedItem = item
    }
    
    func onTapContinue(purchaseManager: PurchaseManager) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            if let selectedItem = self.selectedItem {
                purchaseManager.updatePackage(selectedItem)
                event.send(.close)
            }
        }
        
    }
}
