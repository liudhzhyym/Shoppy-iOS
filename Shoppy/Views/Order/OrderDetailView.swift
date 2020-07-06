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
                    Field(key: "Currency", value: order.currency ?? "USD")
                    Field(key: "Date", value: order.created_at?.description ?? "Unknown")
                    
                    if order.delivered == 1 {
                        Field(key: "Status", value: "Paid")
                        Field(key: "Paid using", value: order.gateway ?? "Unknown")
                        Field(key: "Paid at", value: order.paid_at?.description ?? "Unknown")
                    } else {
                        Field(key: "Status", value: "Not paid")
                    }
                }
                
                Section(header: Text("Payment")) {
                    Field(key: "Price", value: "\(order.price ?? 0)\(Currencies.getSymbol(forCurrencyCode: order.currency ?? "USD") ?? "USD")")
                    Field(key: "Quantity", value: "\(order.quantity ?? 0)")
                    Field(key: "Total", value: "\((order.price ?? 0) * Double(order.quantity ?? 0))\(Currencies.getSymbol(forCurrencyCode: order.currency ?? "USD") ?? "USD")")
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
                
                Section(header: Text("Additional information")) {
                    Field(key: "Hash", value: order.hash ?? "Unknown")
                    
                    if order.is_replacement ?? false {
                        Field(key: "Replacement ID", value: order.replacement_id ?? "Unknown")
                    }
                    
                    if order.coupon_id != nil {
                        Field(key: "Coupon ID", value: order.coupon_id ?? "Unknown")
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
