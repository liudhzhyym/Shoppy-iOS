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
    @State public var icon: String
    @State public var foreground: Color
    @State public var background: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title.uppercased())
                    .font(.footnote)
                    .fontWeight(.light)
                
                Text("\(currency) \(value, specifier: specifier)")
                    .font(.system(size: 22, weight: .bold, design: .default))
                
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .padding(.bottom)
            }
            
            Spacer()
        }
        .padding()
        .foregroundColor(foreground)
        .frame(height: 150)
        .background(background)
        .cornerRadius(20)
    }
}

struct DashboardStatView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DashboardStatView(
                title: "Total orders",
                currency: .constant("$"),
                value: .constant(40),
                specifier: "%.2f",
                icon: "bag.fill",
                foreground: Color("PastelBlueSecondary"),
                background: Color("PastelBlue"))
        }
    }
}
