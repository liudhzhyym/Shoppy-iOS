//
//  ProductSectionView.swift
//  Shoppy
//
//  Created by Victor Lourme on 06/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct ProductSectionView: View {
    @State public var product: Product
    
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
                Text(product.title ?? "Unknown product")
                    .font(.title)
                    .bold()
                
                if !(product.description?.isEmpty ?? true) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ScrollView {
                        Text(product.description!)
                    }.frame(maxHeight: 180)
                }
                
                Field(key: "ID", value: product.id ?? "Unknown")
                Field(key: "Price", value: "\(product.price ?? 0)\(Currencies.getSymbol(forCurrencyCode: product.currency ?? "USD") ?? "USD")")
                Field(key: "Currency", value: product.currency ?? "USD")
                Field(key: "Delivery Type", value: (product.type?.rawValue.capitalized ?? "Unknown"))
                Field(key: "Stock", value: "\(product.stock?.get() ?? -1)")
                Field(key: "Payment methods", value: product.gateways?.map { $0.rawValue }.joined(separator: ", ") ?? "")
                if product.created_at != nil {
                    Field(key: "Creation date", value: Self.formatter.string(from: product.created_at!))
                }
            }.padding()
            
            Spacer()
        }
    }
}

struct ProductSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductSectionView(product: Product())
    }
}
