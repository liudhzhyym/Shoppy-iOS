//
//  ProductCard.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct ProductCard: View {
    @Environment(\.colorScheme) var colorScheme
    @State public var title: String
    @State public var price: Double
    @State public var currency: String
    @State public var stock: Int
    @State public var type: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                HStack {
                    if stock > 0 {
                        Image(systemName: "checkmark")
                        Text("\(stock) in stock - \(price, specifier: "%.2f") \(currency) - \(type)")
                    } else {
                        Image(systemName: "xmark")
                        Text("Out of stock - \(price, specifier: "%.2f") \(currency) - \(type)")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }.lineLimit(0)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(width: 30)
        }
        .padding()
        .foregroundColor(.black)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .padding([.leading, .trailing])
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProductCard(title: "A simple product",
                        price: 20,
                        currency: "EUR",
                        stock: 250,
                        type: "Service")
            
            ProductCard(title: "Another product",
                        price: 50,
                        currency: "EUR",
                        stock: 0,
                        type: "Dynamic")
            
            ProductCard(title: "A very very very very very long title for a product",
                        price: 50,
                        currency: "EUR",
                        stock: 0,
                        type: "File")
        }
    }
}
