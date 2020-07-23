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
    @Environment(\.presentationMode) var presentationMode
    @State public var order: Order
    
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd YYYY"
        
        return df.string(from: date)
    }
    
    var product: some View {
        NavigationLink(destination: ProductDetailView(product: self.order.product!)) {
                Image(systemName: "cube.box")
                    .imageScale(.large)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    HighlightCardView(name: "Total".localized,
                                       value: "\(Currencies.getSymbol(forCurrencyCode: order.currency ?? "USD") ?? "$") \((order.price ?? 0) * Double(order.quantity ?? 0))",
                        icon: "creditcard.fill",
                        foreground: Color("PastelGreenSecondary"),
                        background: Color("PastelGreen"))
                    
                    HighlightCardView(name: "Quantity".localized,
                                       value: "\(order.quantity ?? -1)",
                        icon: "bag.fill",
                        foreground: Color("PastelBlueSecondary"),
                        background: Color("PastelBlue"))
                    
                    HighlightCardView(name: "Payment gateway".localized,
                                       value: "\(order.gateway ?? "BTC")",
                        icon: "bag.fill",
                        foreground: Color("PastelOrangeSecondary"),
                        background: Color("PastelOrange"))
                }.padding(.horizontal)
            }
            
            Text("Information")
                .font(.system(size: 20))
                .bold()
                .padding()
            
            Container {
                ContainerField(name: "Status".localized, value: self.order.delivered == 1 ? "Paid".localized : "Cancelled".localized, icon: "waveform.path.ecg")
                
                ContainerField(name: "Email".localized, value: self.order.email ?? "email@domain.tld", icon: "envelope")
                
                ContainerField(name: "Date", value: self.getDate(date: self.order.created_at ?? Date()), icon: "clock")
                
                ContainerField(name: "Country".localized, value: "\(self.order.agent?.geo?.state_name ?? "State"), \(self.order.agent?.geo?.country ?? "Country")", icon: "map")
                
                ContainerField(name: "IP".localized, value: self.order.agent?.geo?.ip ?? "Unknown", icon: "globe")
                
                if self.order.product?.type == .account {
                    ContainerNavigationButton(title: "See delivered products".localized, icon: "list.dash", destination: AnyView(OrderAccountView(order: self.order)))
                }
            }
            
            Spacer()
        }
        .navigationBarItems(trailing: self.order.product != nil ? product : nil)
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
