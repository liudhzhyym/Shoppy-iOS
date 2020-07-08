//
//  OrdersView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var network: NetworkObserver
    
    var refreshButton: some View {
        Button(action: {
            self.network.getProducts()
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .resizable()
                .frame(width: 26, height: 26)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(network.products ?? [], id: \.id) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCard(title: product.title ?? "Unknown",
                                    price: product.price ?? 0,
                                    currency: product.currency ?? "USD",
                                    stock: product.stock?.get() ?? 0,
                                    type: product.type ?? .account)
                    }
                }
                .padding([.top, .bottom])
            }.id(UUID().uuidString)
                
            .navigationBarTitle("Products")
            .navigationBarItems(trailing: refreshButton)
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
