//
//  NetworkObserver.swift
//  Shoppy
//
//  Created by Victor Lourme on 08/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import Foundation
import SwiftyShoppy
import Combine

class NetworkObserver: ObservableObject {
    ///
    /// Combines
    ///
    let settingsUpdater = PassthroughSubject<Void, Never>()
    let imageUpdater = PassthroughSubject<Void, Never>()
    let analyticsUpdater = PassthroughSubject<Void, Never>()
    
    ///
    /// Observables
    ///
    @Published public var settings: Settings?
    @Published public var analytics: Analytics?
    @Published public var orders: [Order]?
    @Published public var products: [Product]?
    @Published public var image: Data?
    
    ///
    /// Error notifier
    ///
    @Published public var isError: Bool = false
    
    ///
    /// API Key
    ///
    private var key: String
    
    ///
    /// Initialize
    ///
    public init(key: String) {
        // Save key
        self.key = key
        
        // Load observables
        getAnalytics()
        getSettings()
        getOrders()
        getProducts()
    }
    
    ///
    /// Update key
    ///
    public func updateKey(key: String) {
        self.key = key
    }
    
    ///
    /// Get analytics
    ///
    public func getAnalytics() {
        NetworkManager
            .prepare(token: self.key)
            .target(.getAnalytics)
            .asObject(Analytics.self, success: { analytics in
                // Store
                self.analytics = analytics
                
                // Change error state
                self.isError = false
                
                // Notify views
                self.analyticsUpdater.send()
            }, error: { error in
                self.isError = true
            })
    }
    
    ///
    /// Get settings
    ///
    public func getSettings() {
        NetworkManager
            .prepare(token: self.key)
            .target(.getSettings)
            .asObject(Settings.self, success: { settings in
                // Store
                self.settings = settings
                
                // Load image
                if let url = settings.settings?.userAvatarURL {
                    self.getImage(imageURL: url)
                }
                
                // Change error state
                self.isError = false
                
                // Notify views
                self.settingsUpdater.send()
            }, error: { error in
                self.isError = true
            })
    }
    
    ///
    /// Load image
    ///
    private func getImage(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                // Store image
                self.image = data
                
                // Notify
                self.imageUpdater.send()
            }
            
        }.resume()
    }
    
    ///
    /// Get orders
    ///
    public func getOrders() {
        NetworkManager
            .prepare(token: self.key)
            .target(.getOrders)
            .asArray(Order.self, success: { orders in
                self.orders = orders
                self.isError = false
            }, error: { error in
                self.isError = true
            })
    }
    
    ///
    /// Get products
    ///
    public func getProducts() {
        NetworkManager
            .prepare(token: self.key)
            .target(.getProducts)
            .asArray(Product.self, success: { products in
                self.products = products
                self.isError = false
            }, error: { error in
                self.isError = true
            })
    }
}
