//
//  ProductsObservable.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import Foundation
import SwiftyShoppy
import KeychainSwift

class ProductsObservable: ObservableObject {
    @Published public var products: [Product] = []
    
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
                .target(.getProducts)
                .asArray(Product.self, success: { products in
                    self.products = products
                }, error: { error in
                    // Error
                })
        }
    }
}
