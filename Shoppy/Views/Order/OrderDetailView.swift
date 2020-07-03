//
//  OrderDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct OrderDetailView: View {
    @State public var order: Order
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Field(key: "Order ID", value: order.id ?? "Unknown")
                    Field(key: "Product ID", value: order.product_id ?? "Unknown")
                    Field(key: "Price", value: "\(order.price ?? 0)\(Currencies.getSymbol(forCurrencyCode: order.currency ?? "USD") ?? "USD")")
                    Field(key: "Quantity", value: "\(order.quantity ?? 0)")
                    Field(key: "Total", value: "\((order.price ?? 0) * Double(order.quantity ?? 0))\(Currencies.getSymbol(forCurrencyCode: order.currency ?? "USD") ?? "USD")")
                    Field(key: "Currency", value: order.currency ?? "USD")
                    if order.delivered == 1 {
                        Field(key: "Status", value: "Paid")
                    } else {
                        Field(key: "Status", value: "Not paid")
                    }
                    
                    Field(key: "Gateway", value: order.gateway ?? "Unknown")
                }
                
                Section(header: Text("Buyer")) {
                    Field(key: "Email", value: order.email ?? "Unknown")
                    if order.delivered == 1 {
                        Field(key: "Crypto address", value: order.crypto_address ?? "Unknown")
                        Field(key: "Crypto amount", value: "\(order.crypto_amount ?? "")")
                    }
                }
                
                if order.product != nil {
                    Section(header: Text("Product")) {
                        NavigationLink(destination: ProductDetailView(product: order.product!)) {
                            Text("See the product page")
                        }
                    }
                }
            }
                
            .navigationBarTitle("Order")
        }
    }
}

///
/// Preview
///
struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order())
    }
}
