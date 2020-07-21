//
//  ProductCard.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import enum SwiftyShoppy.DeliveryType

struct ProductCard: View {
    @Environment(\.colorScheme) var colorScheme
    @State public var title: String
    @State public var price: Double
    @State public var currency: String
    @State public var stock: Int
    @State public var type: DeliveryType
    
    private func getIconForType() -> String {
        switch type {
            case .account: return "list.bullet.indent"
            case .dynamic: return "link"
            case .file: return "doc"
            case .service: return "person"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: getIconForType())
                .imageScale(.large)
                .font(.headline)
                .foregroundColor(Color("PastelGreenSecondary"))
                .padding()
                .frame(width: 50, height: 50)
                .background(Color("PastelGreen"))
                .cornerRadius(10)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Group {
                    if type == .account || type == .dynamic {
                        if stock > 0 {
                            Text("\(stock) \("in stock".localized)")
                        } else {
                            Text("Out of stock")
                        }
                    } else if type == .file {
                        Text("File")
                    } else {
                        Text("Service")
                    }
                }
                .font(.callout)
                .foregroundColor(.secondary)
            }
            .lineLimit(0)
            
            Spacer()
            
            Text("\(Currencies.getSymbol(forCurrencyCode: currency) ?? "$") \(price, specifier: "%.2f")")
                .font(.headline)
        }
        .padding()
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProductCard(title: "Example.org accounts",
                        price: 20,
                        currency: "USD",
                        stock: 250,
                        type: .account)
            
            ProductCard(title: "How to get rich PDF",
                        price: 50,
                        currency: "EUR",
                        stock: 0,
                        type: .file)
            
            ProductCard(title: "I translate your iOS application",
                        price: 50,
                        currency: "USD",
                        stock: 0,
                        type: .service)
        }
    }
}
