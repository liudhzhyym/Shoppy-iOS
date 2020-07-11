//
//  QueryCard.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct QueryCard: View {
    @State public var query: Query
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(query.subject ?? "")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(query.email ?? "")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .foregroundColor(.black)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .padding([.leading, .trailing])
    }
}

struct QueryCard_Previews: PreviewProvider {
    static var previews: some View {
        QueryCard(query: Query())
    }
}
