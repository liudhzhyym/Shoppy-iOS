//
//  DashboardCardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 20/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct OrderCardView: View {
    @EnvironmentObject var network: NetworkObserver

    @State public var email: String
    @State public var product: String
    @State public var date: Date
    @State public var price: Double
    @State public var currency: String
    @State public var paid: Bool

    private func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MMM dd"

        return dateFormatter.string(from: date)
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: paid == true ? "arrow.down" : "xmark")
                .foregroundColor(Color(paid == true ? "PastelGreenSecondary" : "PastelRedSecondary"))
                .font(.headline)
                .padding(14)
                .frame(width: 40, height: 40)
                .background(Circle().foregroundColor(Color(paid == true ? "PastelGreen" : "PastelRed")))

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

struct OrderCardView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            OrderCardView(email: "example@domain.tld",
                              product: "Translate your website",
                              date: Date(),
                              price: 12.90,
                              currency: "USD",
                              paid: true)
                .listRowInsets(EdgeInsets())

            OrderCardView(email: "example@domain.tld",
                              product: "Translate your website",
                              date: Date(),
                              price: 12.90,
                              currency: "USD",
                              paid: false)
                .listRowInsets(EdgeInsets())
        }
        .environmentObject(NetworkObserver(key: ""))
    }
}
