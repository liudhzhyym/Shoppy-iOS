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
    let metricsUpdater = PassthroughSubject<Void, Never>()
    let imageUpdater = PassthroughSubject<Void, Never>()
    let analyticsUpdater = PassthroughSubject<Void, Never>()
    let errorSubscriber = PassthroughSubject<Void, Never>()
    
    ///
    /// Observables
    ///
    @Published public var settings: Settings?
    @Published public var analytics: Analytics?
    @Published public var orders: [Order] = []
    @Published public var products: [Product] = []
    @Published public var queries: [Query] = []
    @Published public var image: Data?
    
    ///
    /// Single value observables
    ///
    @Published public var totalRevenue: Double = 0
    @Published public var todayRevenue: Double = 0
    
    ///
    /// API Key
    ///
    public var key: String
    
    ///
    /// Initialize
    ///
    public init(key: String) {
        // Save key
        self.key = key
        
        // Load all
        loadAll()
    }
    
    ///
    /// Fetch all data
    ///
    public func loadAll() {
        // Load observables
        getAnalytics()
        getMetrics()
        getSettings()
        getOrders(page: 1)
        getProducts(page: 1)
        getQueries(page: 1)
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
                
                // Notify views
                self.analyticsUpdater.send()
            }, error: { error in
                self.errorSubscriber.send()
            })
    }
    
    ///
    /// Get metrics
    ///
    public func getMetrics() {
        // Get total revenue
        NetworkManager
            .prepare(token: self.key)
            .target(.getMetrics(.revenue, range: 1000))
            .asObject(Metrics.self, success: { metrics in
                // Store
                if let revenue = metrics.value?.value {
                    self.totalRevenue = revenue
                }
                
                // Notify user
                self.metricsUpdater.send()
            }, error: { error in
                self.errorSubscriber.send()
            })
        
        // Get daily revenue
        NetworkManager
            .prepare(token: self.key)
            .target(.getMetrics(.revenue, range: 1))
            .asObject(Metrics.self, success: { metrics in
                // Store
                if let revenue = metrics.value?.value {
                    self.todayRevenue = revenue
                }
                
                // Notify user
                self.metricsUpdater.send()
            }, error: { error in
                self.errorSubscriber.send()
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
                
                // Notify views
                self.settingsUpdater.send()
            }, error: { error in
                self.errorSubscriber.send()
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
    public func getOrders(page: Int) {
        NetworkManager
            .prepare(token: self.key)
            .target(.getOrders(page))
            .asArray(Order.self, success: { orders in
                // Reset
                if page == 1 {
                    self.orders.removeAll()
                }
                
                // Append new orders
                self.orders.append(contentsOf: orders)
            }, error: { error in
                self.errorSubscriber.send()
            })
    }
    
    ///
    /// Get products
    ///
    public func getProducts(page: Int) {
        NetworkManager
            .prepare(token: self.key)
            .target(.getProducts(page))
            .asArray(Product.self, success: { products in
                // Reset
                if page == 1 {
                    self.products.removeAll()
                }
                
                // Append new produts
                self.products.append(contentsOf: products)
            }, error: { error in
                self.errorSubscriber.send()
            })
    }
    
    ///
    /// Get queries
    ///
    public func getQueries(page: Int) {
        NetworkManager
            .prepare(token: self.key)
            .target(.getQueries(page))
            .asArray(Query.self, success: { queries in
                // Reset
                if page == 1 {
                    self.queries.removeAll()
                }
                
                // Sort by date
                let queries_sorted = queries.sorted { (a, b) -> Bool in
                    a.updated_at?.compare(b.updated_at ?? Date()) == .orderedDescending
                }
                
                // Append new produts
                self.queries.append(contentsOf: queries_sorted)
            }, error: { error in
                self.errorSubscriber.send()
            })
    }
}
