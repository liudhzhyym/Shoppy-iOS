//
//  DashboardCardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 20/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct DashboardCardView: View {
    @EnvironmentObject var network: NetworkObserver
    
    @State public var email: String
    @State public var product: String
    @State public var date: Date
    @State public var price: Double
    @State public var currency: String
    @State public var paid: Bool
    
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd"
        
        return df.string(from: date)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: paid == true ? "checkmark" : "xmark")
                .foregroundColor(Color(paid == true ? "PastelGreenSecondary" : "PastelRedSecondary"))
                .font(.headline)
                .padding(14)
                .background(Color(paid == true ? "PastelGreen" : "PastelRed"))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(email)
                    .bold()
                
                Text(getDate(date: date))
                .font(.caption)
                .foregroundColor(.secondary)
                .bold()
            }.lineLimit(0)
            
            Spacer()
            
            Text("\(Currencies.getSymbol(forCurrencyCode: network.settings?.settings?.currency ?? "USD") ?? "$")\(price, specifier: "%.2f")")
                    .font(.system(.headline, design: .rounded))
        }
        .padding()
    }
}

struct DashboardCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            DashboardCardView(email: "example@domain.tld",
                              product: "Translate your website",
                              date: Date(),
                              price: 12.90,
                              currency: "USD",
                              paid: true)
            
            DashboardCardView(email: "example@domain.tld",
                              product: "Translate your website",
                              date: Date(),
                              price: 12.90,
                              currency: "USD",
                              paid: false)
        }
        .environmentObject(NetworkObserver(key: ""))
    }
}
