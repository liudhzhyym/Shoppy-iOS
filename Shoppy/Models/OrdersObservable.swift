//
//  OrdersObservable.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import Foundation
import SwiftyShoppy
import KeychainSwift

class OrdersObservable: ObservableObject {
    @Published public var orders: [Order] = []
    
    init() {
        // Load keychain
        let keychain = KeychainSwift()
        
        // Instance NetworkManager
        let nm = NetworkManager(token: keychain.get("key") ?? "")
        
        // Get orders
        nm.getOrders() { orders, error in
            // Check for error
            if error != nil {
                return
            }
            
            // Store orders
            if let orders = orders {
                self.orders = orders
            }
        }
    }
}
