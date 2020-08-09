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
    // Network
    @EnvironmentObject var network: NetworkObserver

    // Presentation Mode
    @Environment(\.presentationMode) var presentation

    // Product
    @State public var product: Product

    // Events
    @State private var showSafari = false
    @State private var isPresented = false
    @State private var allowEditing = true

    ///
    /// Get formatted string from Date object
    /// - parameters:
    ///     - date as Date()
    /// - returns:
    ///     - Formatted string as "dd/MM"
    ///
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM"

        return df.string(from: date)
    }

    ///
    /// Delete a product
    ///
    private func deleteProduct() {
        // Get product ID
        guard let id = product.id else {
            return
        }

        // Delete item
        NetworkManager
            .prepare(token: network.key)
            .target(.deleteProduct(id))
            .asObject(ResourceUpdate<Product>.self, success: { _ in
                // Reload products
                self.network.getProducts(page: 1)

                // Dismiss
                self.presentation.wrappedValue.dismiss()
            }, error: { error in
                print(error)
            })
    }

    ///
    /// Show action
    ///
    var showAction: some View {
        Button(action: {
            self.isPresented = true
        }) {
            Image(systemName: "ellipsis")
                .imageScale(.large)
        }
        .disabled(!self.allowEditing)
    }

    ///
    /// Body
    ///
    var body: some View {
        List {
            Section(header: Text("Information")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        HighlightCardView(name: "Price",
                                          value: "\(Currencies.getSymbol(forCurrencyCode: product.currency ?? "USD") ?? "$") \(String(format: "%.2f", product.price ?? -1))",
                            icon: "dollarsign.circle.fill",
                            foreground: Color("PastelRedSecondary"),
                            background: Color("PastelRed"))

                        HighlightCardView(name: "Stock",
                                          value: "\(product.type == .account ? String(product.stock?.get() ?? 0) : "∞")",
                            icon: "bag.fill",
                            foreground: Color("PastelGreenSecondary"),
                            background: Color("PastelGreen"))

                        HighlightCardView(name: "Creation date",
                                          value: getDate(date: product.created_at ?? Date()),
                                          icon: "calendar",
                                          foreground: Color("PastelBlueSecondary"),
                                          background: Color("PastelBlue"))
                    }.padding(.horizontal)
                }
                .listRowInsets(EdgeInsets())
                .padding([.top, .bottom])

                Label(label: "Title",
                      value: product.title ?? "Unknown",
                      icon: "cube.box.fill")

                Label(label: "Type",
                      value: product.type?.rawValue.capitalized ?? "Service",
                      icon: "aspectratio.fill")

                NavigationLink(destination: ProductDetailledView(name: "Description".localized, value: self.product.description ?? "Empty description.".localized)) {
                    Label(label: "See the description",
                          icon: "a")
                }
            }

            if product.type == .account || product.type == .dynamic {
                Section(header: Text(product.type == .account ? "Account" : "Dynamic")) {
                    if product.type == .account {
                        NavigationLink(destination: ProductAccountView(accounts: product.accounts)) {
                            Label(label: "See the list of account",
                                  icon: "rectangle.stack.person.crop.fill",
                                  color: .red)
                        }
                    } else {
                        Label(label: "URL",
                              value: product.dynamic_url ?? "Unknown",
                              icon: "link.fill",
                              color: .red)
                    }

                    Label(label: "Minimum per order",
                          value: "\(product.quantity?.min ?? 0)",
                        icon: "minus.circle.fill",
                        color: .red)

                    Label(label: "Maximum per order",
                          value: "\(product.quantity?.max ?? 0)",
                        icon: "plus.circle.fill",
                        color: .red)
                }
            }

            Section(header: Text("Additional information")) {
                Label(label: "Unlisted",
                      value: product.unlisted == true ? "Yes".localized : "No".localized,
                      icon: "eye.slash.fill",
                      color: .green)

                Label(label: "Currency",
                      value: product.currency ?? "USD",
                      icon: "dollarsign.circle.fill",
                      color: .green)

                Label(label: "ID",
                      value: product.id ?? "Unknown",
                      icon: "number",
                      color: .green)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Product")
        .navigationBarItems(trailing: showAction)
        .actionSheet(isPresented: $isPresented) {
            ActionSheet(title: Text("Select an action"), buttons: [
                .default(Text("Open in Safari"), action: { self.showSafari.toggle() }),
                .destructive(Text("Delete product"), action: self.deleteProduct),
                .cancel()
            ])
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: "https://shoppy.gg/product/\(self.product.id ?? "")")!)
                .edgesIgnoringSafeArea(.bottom)
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
                }, error: { _ in
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
