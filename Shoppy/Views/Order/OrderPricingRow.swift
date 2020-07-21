//
//  OrderPricingRow.swift
//  Shoppy
//
//  Created by Victor Lourme on 21/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct OrderPricingRow: View {
    @State public var icon: String
    @State public var currency: String
    @State public var price: Double
    @State public var quantity: Int = 1
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .imageScale(.large)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(Currencies.getSymbol(forCurrencyCode: currency) ?? "$") \(price, specifier: "%.2f")")
                    .bold()
                
                Text("✕ ")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                + Text("\(quantity)")
                    .bold()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Total")
                    .foregroundColor(.secondary)
                
                Text("\(Currencies.getSymbol(forCurrencyCode: currency) ?? "$") \(Double(quantity) * price, specifier: "%.2f")")
                    .bold()
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OrderPricingRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderPricingRow(icon: "bag", currency: "EUR", price: 45)
    }
}
