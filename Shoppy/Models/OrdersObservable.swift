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
        update()
    }
    
    public func update() {
        // Load keychain
        let keychain = KeychainSwift()
        
        // Instance NetworkManager
        if let key = keychain.get("key") {
            NetworkManager
                .prepare(token: key)
                .target(.getOrders)
                .asArray(Order.self,
                         success: { orders in
                            self.orders = orders
                }, error: { error in
                    // Error
                })
        }
    }
}
