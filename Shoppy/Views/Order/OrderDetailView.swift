//
//  OrderDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Order
import enum SwiftyShoppy.Gateways

struct OrderDetailView: View {
    // Order
    @State public var order: Order
    
    ///
    /// Get a formatted date from Date object
    /// - parameters:
    ///     - date as Date
    /// - returns:
    ///     - Formatted string as "HH:mm MMM dd YYYY"
    ///
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd YYYY"
        
        return df.string(from: date)
    }
    
    ///
    /// Body
    ///
    var body: some View {
        List {
            Section(header: Text("Information")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        HighlightCardView(name: "Total",
                                          value: "\(Currencies.getSymbol(forCurrencyCode: order.currency ?? "USD") ?? "$") \((order.price ?? 0) * Double(order.quantity ?? 0))",
                            icon: "cart.fill",
                            foreground: Color("PastelGreenSecondary"),
                            background: Color("PastelGreen"))
                        
                        HighlightCardView(name: "Quantity",
                                          value: "\(order.quantity ?? -1)",
                            icon: "bag.fill",
                            foreground: Color("PastelBlueSecondary"),
                            background: Color("PastelBlue"))
                        
                        HighlightCardView(name: "Payment gateway",
                                          value: "\(order.gateway ?? "BTC")",
                            icon: "creditcard.fill",
                            foreground: Color("PastelOrangeSecondary"),
                            background: Color("PastelOrange"))
                    }.padding(.horizontal)
                }
                .listRowInsets(EdgeInsets())
                .padding([.top, .bottom])
                
                Label(label: "Status",
                      value: order.delivered == 1 ? "Paid".localized : "Cancelled".localized,
                      icon: "cube.box.fill")
                
                Label(label: "Date",
                      value: getDate(date: order.created_at ?? Date()),
                      icon: "clock.fill")
            }
            
            Section(header: Text("Buyer")) {
                Label(label: "Email",
                      value: order.email ?? "Unknown",
                      icon: "envelope.fill",
                      color: .green)
                
                Label(label: "Location",
                      value: "\(order.agent?.geo?.state_name ?? "State"), \(order.agent?.geo?.country ?? "Country")",
                    icon: "map.fill",
                    color: .green)
                
                Label(label: "IP",
                      value: order.agent?.geo?.ip ?? "Unknown",
                      icon: "globe",
                      color: .green)
            }
            
            if order.gateway != Gateways.paypal.rawValue && order.gateway != Gateways.stripe.rawValue {
                Section(header: Text("Crypto")) {
                    Label(label: "Amount",
                          value: order.crypto_amount ?? "0",
                          icon: "bitcoinsign.circle.fill",
                          color: .red)
                    
                    Label(label: "Address",
                          value: order.crypto_address ?? "Unknown",
                          icon: "arrow.branch",
                          color: .red)
                }
            }
            
            Section(header: Text("Product")) {
                Label(label: "Product",
                      value: order.product?.title ?? "Unknown",
                      icon: "doc.plaintext")
                
                // MARKS: This could cause a crash.
                if order.product != nil {
                    NavigationLink(destination: ProductDetailView(product: order.product!)) {
                        Label(label: "See the product",
                              icon: "cube.box",
                              color: .orange)
                    }
                }
            }
            
            Section(header: Text("Additional information")) {
                Label(label: "ID",
                      value: order.id ?? "Unknown",
                      icon: "number",
                      color: .purple)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Invoice")
    }
}

///
/// Preview
///
struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderDetailView(order: Order())
        }
    }
}
