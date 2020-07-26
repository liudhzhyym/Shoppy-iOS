//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 02/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Product
import struct SwiftyShoppy.ResourceUpdate
import class SwiftyShoppy.NetworkManager
import KeychainSwift

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var network: NetworkObserver
    
    @State public var product: Product
    @State private var isPresented = false
    @State private var editMode = false
    @State private var allowEditing = true
    
    private let keychain = KeychainSwift()
    
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM"
        
        return df.string(from: date)
    }
    
    // Edit product
    private func editProduct() {
        self.editMode = true
    }
    
    // Delete product
    private func deleteProduct() {
        // Get product ID
        guard let id = product.id else {
            return
        }
        
        // Get token
        if let key = keychain.get("key") {
            NetworkManager
                .prepare(token: key)
                .target(.deleteProduct(id))
                .asObject(ResourceUpdate<Product>.self, success: { update in
                    // Reload products
                    self.network.getProducts(page: 1)
                    
                    // Dismiss
                    self.presentation.wrappedValue.dismiss()
                }, error: { error in
                    print(error)
                })
        }
    }
    
    // Open action sheet
    var showAction: some View {
        Button(action: {
            self.isPresented = true
        }) {
            Image(systemName: "slider.horizontal.3")
                .imageScale(.large)
        }
        .disabled(!self.allowEditing)
    }
    
    // Body
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    HighlightCardView(name: "Price".localized,
                                      value: "\(Currencies.getSymbol(forCurrencyCode: product.currency ?? "USD") ?? "$") \(String(format: "%.2f", product.price ?? -1))",
                                      icon: "dollarsign.circle.fill",
                                      foreground: Color("PastelRedSecondary"),
                                      background: Color("PastelRed"))
                    
                    HighlightCardView(name: "Stock".localized,
                                      value: "\(product.type == .account ? String(product.stock?.get() ?? 0) : "∞")",
                                      icon: "bag.fill",
                                      foreground: Color("PastelGreenSecondary"),
                                      background: Color("PastelGreen"))
                    
                    HighlightCardView(name: "Creation date".localized,
                                      value: getDate(date: product.created_at ?? Date()),
                                      icon: "calendar",
                                      foreground: Color("PastelBlueSecondary"),
                                      background: Color("PastelBlue"))
                }.padding()
            }
            
            Container {
                ContainerField(name: "Title".localized, value: self.product.title ?? "Product Name", icon: "cube")
                
                ContainerField(name: "Type".localized, value: self.product.type?.rawValue.capitalized.localized ?? "Service", icon: "aspectratio")
                
                ContainerNavigationButton(title: "See the description".localized, icon: "text.alignleft", destination: AnyView(ProductDetailledView(name: "Description", value: self.product.description ?? "Empty description.")))
                
                if self.product.type ?? .service == .account {
                    ContainerNavigationButton(title: "See accounts in stock".localized, icon: "list.dash", destination: AnyView(ProductAccountView(accounts: self.product.accounts)))
                }
                
                ContainerField(name: "Unlisted".localized, value: self.product.unlisted == true ? "Yes".localized : "No".localized, icon: "eye.slash")
                
                ContainerField(name: "ID", value: self.product.id ?? "Unknown", icon: "number")
            }
                
            Spacer()
        }
        .navigationBarTitle("Product")
        .navigationBarItems(trailing: showAction)
        .sheet(isPresented: $editMode) {
            ProductEditView(product: self.product, network: self.network, isEdit: true)
        }
        .actionSheet(isPresented: $isPresented) {
            ActionSheet(title: Text("Select an action"), buttons: [
                .default(Text("Edit product"), action: self.editProduct),
                .destructive(Text("Delete product"), action: self.deleteProduct),
                .cancel()
            ])
        }
        .onAppear {
            // Get ID
            guard let id = self.product.id else {
                return
            }
            
            // Check if product still exists
            NetworkManager
                .prepare(token: self.network.key)
                .target(.getProduct(id))
                .asObject(Product.self, success: { _ in
                    print("Product exists")
                }, error: { error in
                    print("Product does not exists")
                    self.allowEditing = false
                })
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailView(product: Product())
        }
    }
}
