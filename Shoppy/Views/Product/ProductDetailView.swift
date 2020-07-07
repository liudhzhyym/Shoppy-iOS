//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 02/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct ProductDetailView: View {
    @State public var product: Product
    
    var body: some View {
        Form {
            Section(header: Text("Product")) {
                // Description
                if product.description != nil {
                    NavigationLink(destination: ProductDetailledView(name: "Description", value: product.description!)) {
                        Text("See product description")
                    }
                }
                
                Field(key: "Delivery type", value: product.type?.rawValue.capitalized ?? "Unknown")
                Field(key: "Price", value: "\(product.price ?? -1)")
                Field(key: "Currency", value: product.currency ?? "Unknown")
            }
            
            Section(header: Text("Stock")) {
                Field(key: "Stock", value: "\(product.stock?.get() ?? -1)")
                Field(key: "Minimum quantity", value: "\(product.quantity?.min ?? -1)")
                Field(key: "Maximum quantity", value: "\(product.quantity?.max ?? -1)")
            }
            
            if product.gateways?.count ?? 0 > 0 {
                Section(header: Text("Gateways")) {
                    List {
                        ForEach(product.gateways!, id: \.self) { gateway in
                            Text("\(gateway.rawValue)")
                        }
                    }
                }
            }
            
            if product.email?.enabled ?? false {
                Section(header: Text("Email")) {
                    NavigationLink(destination: ProductDetailledView(name: "Email", value: product.email?.value ?? "")) {
                        Text("See email text")
                    }
                }
            }
            
            if product.webhook_urls?.count ?? 0 > 0 {
                Section(header: Text("Webhooks")) {
                    List {
                        ForEach(product.webhook_urls!, id: \.self) { webhook in
                            Text(webhook)
                        }
                    }
                }
            }
            
            Section(header: Text("Additional information")) {
                Field(key: "Unlisted", value: product.unlisted ?? false ? "Yes" : "No")
                Field(key: "ID", value: product.id ?? "Unknown")
                Field(key: "Created at", value: product.created_at?.description ?? "Unknown")
                Field(key: "Updated at", value: product.updated_at?.description ?? "Unknown")
            }
        }.navigationBarTitle(product.title ?? "Product")
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product())
    }
}
