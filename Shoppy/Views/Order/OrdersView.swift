//
//  OrdersView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct OrdersView: View {
    @EnvironmentObject var network: NetworkObserver
    @State private var page: Int = 1
    
    private func loadMore() {
        // Increment page
        self.page += 1
        
        // Load more
        self.network.getOrders(page: self.page)
    }
    
    var refreshButton: some View {
        Button(action: {
            self.network.getOrders(page: 1)
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .resizable()
                .frame(width: 26, height: 26)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(network.orders, id: \.id) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderCard(email: order.email ?? "",
                                  description: order.product?.title ?? "",
                                  price: (order.price ?? 0) * Double(order.quantity ?? 0),
                                  currency: order.currency ?? "",
                                  paid: order.delivered ?? 0)
                    }
                }
                
                Text("\(network.orders.count) orders")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                if network.orders.count >= (25 * self.page) {
                    Button(action: loadMore) {
                        Text("Try to load more")
                    }.padding()
                }
                
                Spacer()
            }
            .id(UUID().uuidString)
            .navigationBarTitle("Orders")
            .navigationBarItems(trailing: refreshButton)
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
