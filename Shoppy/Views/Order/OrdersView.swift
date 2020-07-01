//
//  OrdersView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject private var orders = OrdersObservable()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(orders.orders, id: \.id) { order in
                    NavigationLink(destination: EmptyView()) {
                        OrderCard(email: order.email ?? "",
                                  description: order.product?.title ?? "",
                                  price: (order.price ?? 0) * Double(order.quantity ?? 0),
                                  currency: order.currency ?? "",
                                  paid: order.delivered ?? 0)
                    }
                    
                }
                .padding([.top, .bottom])
            }
            .navigationBarTitle("Orders")
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
