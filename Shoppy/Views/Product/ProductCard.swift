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
        HStack(spacing: 15) {
            Image(systemName: getIconForType())
                .foregroundColor(Color("PastelGreenSecondary"))
                .font(.headline)
                .padding(14)
                .frame(width: 40, height: 40)
                .background(Circle().foregroundColor(Color("PastelGreen")))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Group {
                    if type == .account {
                        if stock > 0 {
                            Text("\(stock) \("in stock".localized)")
                        } else {
                            Text("Out of stock")
                        }
                    } else if type == .file {
                        Text("File")
                    } else if type == .dynamic {
                        Text("Dynamic")
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
        List {
            ProductCard(title: "Example.org accounts",
                        price: 20,
                        currency: "USD",
                        stock: 250,
                        type: .account)
                .listRowInsets(EdgeInsets())
            
            ProductCard(title: "How to get rich PDF",
                        price: 50,
                        currency: "EUR",
                        stock: 0,
                        type: .file)
                .listRowInsets(EdgeInsets())
            
            ProductCard(title: "I translate your iOS application",
                        price: 50,
                        currency: "USD",
                        stock: 0,
                        type: .service)
                .listRowInsets(EdgeInsets())
        }
    }
}
