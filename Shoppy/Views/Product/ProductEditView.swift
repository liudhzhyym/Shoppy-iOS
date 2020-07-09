//
//  ProductEditView.swift
//  Shoppy
//
//  Created by Victor Lourme on 09/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import KeyboardObserving

struct ProductEditView: View {
    // Environment
    @Environment(\.presentationMode) var presentation
    
    // Init
    @State public var product: Product
    @State public var network: NetworkObserver
    @State public var isEdit: Bool = false
    
    // Error
    @State private var showError = false
    
    // Bindings
    @State private var title = ""
    @State private var price = ""
    @State private var type: DeliveryType = .account
    @State private var description = ""
    @State private var isUnlisted = false
    
    // Update function
    private func submit() {
        // Override to product
        self.product.title = self.title
        self.product.price = Double(self.price)
        self.product.type = self.type
        self.product.unlisted = self.isUnlisted
        self.product.description = self.description
        
        // Submit
        if self.isEdit {
            NetworkManager
                .prepare(token: self.network.key)
                .target(.updateProduct(self.product))
                .asObject(ResourceUpdate<Product>.self, success: { success in
                    if success.status == true {
                        self.close()
                    }
                }, error: { error in
                    self.showError = true
                })
        } else {
            NetworkManager
                .prepare(token: self.network.key)
                .target(.createProduct(self.product))
                .asObject(ResourceUpdate<Product>.self, success: { success in
                    if success.status == true {
                        self.close()
                    }
                }, error: { error in
                    self.showError = true
                })
        }
    }
    
    // Close
    private func close() {
        // Update products
        self.network.getProducts(page: 1)
        
        // Close window
        self.presentation.wrappedValue.dismiss()
    }
    
    // Done View
    var doneButton: some View {
        Button(action: submit) {
            Text("Done")
                .bold()
        }
    }
    
    // Main View
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Required fields")) {
                    TextField("Name (128 chars max)", text: $title)
                    TextField("Price (10.000 max)", text: $price)
                        .keyboardType(.decimalPad)
                    
                    Picker(selection: $type, label: Text("Type")) {
                        ForEach(DeliveryType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                }
                
                Section(header: Text("Optional fields")) {
                    Toggle(isOn: $isUnlisted) {
                        Text("Unlisted")
                    }
                    
                    TextField("Description (10.000 chars max)", text: $description)
                }
            }
                
            .keyboardObserving()
            .navigationBarTitle(isEdit == true ? "Edit a product" : "Create a product", displayMode: .inline)
            .navigationBarItems(trailing: doneButton)
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                message: Text("Please check you filled required fields correctly."),
                dismissButton: .cancel())
        }
        .onAppear {
            // Load existant settings
            if self.isEdit {
                self.title = self.product.title ?? ""
                self.price = "\(self.product.price ?? 0)"
                self.type = self.product.type ?? .account
                self.isUnlisted = self.product.unlisted ?? false
                self.description = self.product.description ?? ""
            }
        }
    }
}

struct ProductEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditView(product: Product(), network: NetworkObserver(key: ""))
    }
}
