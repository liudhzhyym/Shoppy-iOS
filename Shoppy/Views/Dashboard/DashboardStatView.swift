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
            VStack(alignment: .leading) {
                Text(title.uppercased())
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Text("\(currency) \(value, specifier: specifier)")
                    .font(.system(size: 22))
                    .bold()
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 180)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
}

struct DashboardStatView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DashboardStatView(title: "Total orders", currency: .constant("$"), value: .constant(40), specifier: "%.2f")
        }
    }
}
