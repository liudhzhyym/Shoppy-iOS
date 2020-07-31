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
    @State private var orders: [Order] = []
    
    ///
    /// Load more results
    ///
    private func loadMore() {
        // Increment page
        self.page += 1
        
        // Load more
        self.network.getOrders(page: self.page)
    }
    
    ///
    /// Get orders with filters
    ///
    private func getOrders() -> [Order] {
        return self.network.orders.filter({ (order: Order) -> Bool in
            if self.showPaidOnly {
                return order.delivered == 1
            } else {
                return true
            }
        })
    }
    
    ///
    /// Paid Only buttons
    ///
    var paidOnlyButton: some View {
        Button(action: {
            // Toggle paid only
            self.showPaidOnly.toggle()
            
            // Reload orders
            self.orders = self.getOrders()
        }) {
            Image(systemName: self.showPaidOnly == true ? "checkmark.circle.fill" : "checkmark")
                .imageScale(.large)
        }
    }
    
    ///
    /// Refresh button
    ///
    var refreshButton: some View {
        Button(action: {
            self.page = 1
            self.network.getOrders(page: self.page)
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .imageScale(.large)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("\(orders.count) \("orders".localized)".uppercased())) {
                    ForEach(orders, id: \.id) { (order: Order) in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderCardView(email: order.email ?? "",
                                              product: order.product?.title ?? "",
                                              date: order.created_at ?? Date(),
                                              price: (order.price ?? 0) * Double(order.quantity ?? 0),
                                              currency: order.currency ?? "USD",
                                              paid: order.delivered == 1)
                                .onAppear {
                                    if self.orders.last == order {
                                        if self.network.orders.count >= (self.page * 25) {
                                            self.loadMore()
                                        }
                                    }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.trailing)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Orders")
            .navigationBarItems(leading: paidOnlyButton, trailing: refreshButton)
            
            Text("No order selected")
        }
        .onAppear {
            self.orders = self.getOrders()
        }
        .onReceive(self.network.ordersUpdater) {
            self.orders = self.getOrders()
        }
    }
}


struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
            .environmentObject(NetworkObserver(key: ""))
    }
}
