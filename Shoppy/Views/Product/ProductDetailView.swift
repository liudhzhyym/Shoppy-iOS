//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 02/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import FancyScrollView

struct ProductDetailView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    @State public var product: Product
    
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    var body: some View {
        FancyScrollView(headerHeight: 350,
                        scrollUpHeaderBehavior: .parallax,
                        scrollDownHeaderBehavior: .sticky,
                        header: {
                            Image(uiImage: ((imageLoader.image != nil) ?
                                UIImage(data: imageLoader.image!): UIImage(systemName: "xmark"))!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
        }) {
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
                    Field(key: "Delivery Type", value: (product.type?.capitalized ?? "Unknown"))
                    Field(key: "Stock", value: "\(product.stock ?? 0)")
                    
                    Field(key: "Payment methods", value: product.gateways?.joined(separator: ", ") ?? "Unknown")
                    if product.created_at != nil {
                        Field(key: "Creation date", value: Self.formatter.string(from: product.created_at!))
                    }
                }.padding()
                
                Spacer()
            }
        }
        .onAppear() {
            if let url = self.product.image?.url {
                print(url)
                self.imageLoader.setImage(imageURL: url)
            }
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product())
    }
}
