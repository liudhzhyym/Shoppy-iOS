//
//  QueryCard.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import enum SwiftyShoppy.QueryStatus

struct QueryCard: View {
    @State public var email: String
    @State public var message: String
    @State public var date: Date
    @State public var status: QueryStatus
    
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd"
        
        return df.string(from: date)
    }
    
    private func getIconForStatus() -> String {
        switch status {
            case .Closed: return "xmark.rectangle"
            case .Open: return "envelope"
            case .Replied: return "envelope.open"
            case .UserReply: return "envelope.badge"
        }
    }
    
    private func getColorForStatus(_ secondary: Bool = false) -> String {
        switch status {
            case .Closed: return secondary ? "PastelRedSecondary" : "PastelRed"
            case .Open: return secondary ? "PastelGreenSecondary" : "PastelGreen"
            case .UserReply,
                 .Replied:
                return secondary ? "PastelOrangeSecondary" : "PastelOrange"
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: getIconForStatus())
                .padding(14)
                .font(.headline)
                .foregroundColor(Color(getColorForStatus(true)))
                .frame(width: 40, height: 40)
                .background(Circle().foregroundColor(Color(getColorForStatus())))
            
            VStack(alignment: .leading) {
                Text(email)
                    .bold()
                
                Text("\(message) — \(getDate(date: date))")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }.lineLimit(0)
        }
        .padding()
    }
}

struct QueryCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            List {
                NavigationLink(destination: EmptyView()) {
                    QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .Open)
                }.listRowInsets(EdgeInsets())
                
                NavigationLink(destination: EmptyView()) {
                    QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .Closed)
                }.listRowInsets(EdgeInsets())
                
                NavigationLink(destination: EmptyView()) {
                    QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .Replied)
                }.listRowInsets(EdgeInsets())
                
                NavigationLink(destination: EmptyView()) {
                    QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .UserReply)
                }.listRowInsets(EdgeInsets())
            }
        }
    }
}
