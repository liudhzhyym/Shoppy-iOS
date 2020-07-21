//
//  OrdersView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Order

struct OrdersView: View {
    @EnvironmentObject var network: NetworkObserver
    @State private var page: Int = 1
    @State private var showPaidOnly = false
    
    private func loadMore() {
        // Increment page
        self.page += 1
        
        // Load more
        self.network.getOrders(page: self.page)
    }
    
    var paidOnlyButton: some View {
        Button(action: {
            self.showPaidOnly.toggle()
        }) {
            Image(systemName: self.showPaidOnly == true ? "checkmark.circle.fill" : "checkmark")
                .imageScale(.large)
        }
    }
    
    var refreshButton: some View {
        Button(action: {
            self.network.getOrders(page: 1)
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .imageScale(.large)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.network.orders.filter({ (order: Order) -> Bool in
                    if self.showPaidOnly {
                        return order.delivered == 1
                    } else {
                        return true
                    }
                }), id: \.id) { (order: Order) in
                    Group {
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            DashboardCardView(email: order.email ?? "",
                                              product: order.product?.title ?? "",
                                              date: order.created_at ?? Date(),
                                              price: (order.price ?? 0) * Double(order.quantity ?? 0),
                                              currency: order.currency ?? "USD",
                                              paid: order.delivered == 1)
                        }.buttonStyle(PlainButtonStyle())
                        
                        Divider()
                    }
                }
                
                Text("\(network.orders.count) \("orders".localized)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                if network.orders.count >= (25 * self.page) {
                    Button(action: loadMore) {
                        Text("Try to load more")
                    }.padding()
                }
                
                Spacer()
            }
            .id(UUID())
            .navigationBarTitle("Orders")
            .navigationBarItems(leading: paidOnlyButton, trailing: refreshButton)
        }
    }
}


struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
