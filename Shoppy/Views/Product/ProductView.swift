//
//  OrdersView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Product

struct ProductView: View {
    @EnvironmentObject var network: NetworkObserver
    @State private var page: Int = 1
    @State private var isPresented = false
    
    private func loadMore() {
        // Increment page
        self.page += 1
        
        // Load more
        self.network.getProducts(page: self.page)
    }
    
    var refreshButton: some View {
        Button(action: {
            self.network.getProducts(page: self.page)
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .imageScale(.large)
        }
    }
    
    var addButton: some View {
        Button(action: {
            self.isPresented = true
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("\(network.products.count) \("products".localized)".uppercased()),
                        footer: Button(action: loadMore) {
                            if network.products.count >= (25 * self.page) {
                                Text("Try to load more")
                            }
                }) {
                    ForEach(network.products, id: \.id) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCard(title: product.title ?? "Unknown",
                                        price: product.price ?? 0,
                                        currency: product.currency ?? "USD",
                                        stock: product.stock?.get() ?? 0,
                                        type: product.type ?? .account)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.trailing)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Products")
            .navigationBarItems(leading: refreshButton, trailing: addButton)
            
            Text("No product selected")
        }
        .sheet(isPresented: $isPresented) {
            ProductEditView(product: Product(), network: self.network)
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView()
    }
}
