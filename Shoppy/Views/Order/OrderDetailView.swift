//
//  OrderDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Order
import enum SwiftyShoppy.DeliveryType

struct OrderDetailView: View {
    @State public var order: Order
    
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd YYYY"
        
        return df.string(from: date)
    }
    
    private func copyToPasteBoard(text: String?) {
        let pasteboard = UIPasteboard()
        pasteboard.string = text
    }
    
    var body: some View {
            ScrollView {
                VStack {
                    Group {
                        Spacer()
                        
                        OrderDetailRow(icon: "person", topText: order.email ?? "Unknown email", bottomText: "In \(order.agent?.geo?.country ?? "country") using \(order.agent?.data?.platform ?? "desktop")")
                            .contextMenu {
                                Button(action: {
                                    self.copyToPasteBoard(text: self.order.email)
                                }) {
                                    Text("Copy email")
                                    Image(systemName: "doc.on.doc")
                                }
                                
                                Button(action: {
                                    self.copyToPasteBoard(text: self.order.agent?.geo?.ip)
                                }) {
                                    Text("Copy IP")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                        
                        Divider()
                        
                        if order.delivered == 1 {
                            OrderDetailRow(icon: "checkmark", topText: "Paid", bottomText: getDate(date: order.paid_at ?? Date()))
                        } else {
                            OrderDetailRow(icon: "xmark", topText: "Cancelled", bottomText: "Order was not paid")
                        }
                        
                        Divider()
                        
                        OrderPricingRow(icon: "bag", currency: order.currency ?? "USD", price: order.price ?? 1, quantity: order.quantity ?? 0)
                        
                        Divider()
                    }
                    
                    Group {
                        OrderDetailRow(icon: "creditcard", topText: order.gateway ?? "Bitcoin", bottomText: "Payment gateway")
                        
                        Divider()
                        
                        OrderDetailRow(icon: "cube", topText: order.product?.title ?? "Product", bottomText: order.product_id ?? "Product ID")
                            .contextMenu {
                                NavigationLink(destination: ProductDetailView(product: self.order.product!)) {
                                    Text("See product")
                                    Image(systemName: "cube")
                                }
                                
                                if self.order.product?.type == DeliveryType.account {
                                    NavigationLink(destination: OrderAccountView(order: self.order)) {
                                        Text("See delivered products")
                                        Image(systemName: "list.dash")
                                    }
                                }
                                
                                Button(action: {
                                    self.copyToPasteBoard(text: self.order.product_id)
                                }) {
                                    Text("Copy product ID")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                        
                        Divider()
                        
                        OrderDetailRow(icon: "calendar", topText:  getDate(date: order.created_at ?? Date()), bottomText: order.id ?? "Invoice ID")
                            .contextMenu {
                                Button(action: {
                                    self.copyToPasteBoard(text: self.order.id)
                                }) {
                                    Text("Copy invoice ID")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                        
                        Spacer()
                    }
                }
                .font(.system(.body, design: .rounded))
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding([.leading, .trailing], 25)
                .padding([.top, .bottom], 20)
                .navigationBarTitle("Invoice")
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
