//
//  DashboardStatView.swift
//  Shoppy
//
//  Created by Victor Lourme on 20/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct DashboardStatView: View {
    @State public var title: String
    @Binding public var currency: String
    @Binding public var value: Double
    @State public var specifier: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title.uppercased())
                    .foregroundColor(Color.white.opacity(0.6))
                    .font(.headline)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("\(currency) \(value, specifier: specifier)")
                }
                .font(.system(size: 42, weight: .bold, design: .default))
            }
            .foregroundColor(.white)
            
            Spacer()
        }.frame(width: 200)
    }
}

struct DashboardStatView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardStatView(title: "Total orders", currency: .constant("$"), value: .constant(40), specifier: "%.2f")
    }
}
