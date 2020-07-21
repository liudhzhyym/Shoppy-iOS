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
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: getIconForStatus())
                .padding(14)
                .font(.headline)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(email)
                    .bold()
                
                Text("\(message) — \(getDate(date: date))")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct QueryCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .Open)
            
            Divider()
            
            QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .Closed)
            
            Divider()
            
            QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .Replied)
            
            Divider()
            
            QueryCard(email: "email@domain.tld", message: "API Testing", date: Date(), status: .UserReply)
        }
    }
}
