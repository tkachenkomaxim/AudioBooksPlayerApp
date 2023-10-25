//
//  StoreService.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation
import StoreKit
import SwiftUI

final class StoreService: ObservableObject {
    
    // MARK: - Public Props
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
    
    // MARK: - Private Props
    
    private let productIds = ["subscription.premium"]
    
    @Published
    private(set) var products: [Product] = []
    
    @Published
    private(set) var purchasedProductIDs = Set<String>()
    
    private static var userDefaults = UserDefaults.standard
    
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    // MARK: - Lifecycle
    
    init() {
        
        self.updates = observeTransactionUpdates()
    }
    
    deinit {
        
        self.updates?.cancel()
    }
    
    // MARK: - Public Func
    
    func purchase() async throws -> Bool {
        
        let product = try await Product.products(for: productIds)
        let result = try await product.first?.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
           
            await transaction.finish()
            await self.updatePurchasedProducts()
            
            return true
            
        default:
            break
        }
        
        return false
    }
    
    func updatePurchasedProducts() async {
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        self.hasPro = !self.purchasedProductIDs.isEmpty
    }
    
    // MARK: - Private Func
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            
            for await _ in Transaction.updates {
                
                await self.updatePurchasedProducts()
            }
        }
    }
}
