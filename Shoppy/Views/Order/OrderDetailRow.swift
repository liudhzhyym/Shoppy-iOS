//
//  OrderDetailRow.swift
//  Shoppy
//
//  Created by Victor Lourme on 21/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct OrderDetailRow: View {
    @State public var icon: String
    @State public var topText: String
    @State public var bottomText: String?
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
                .imageScale(.large)
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(topText)
                    .bold()
                Text(bottomText ?? "")
                    .foregroundColor(.secondary)
            }.lineLimit(0)
            
            Spacer()
        }
        .padding()
    }
}

struct OrderDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailRow(icon: "person", topText: "Victor", bottomText: "victor@gmail.com")
    }
}
