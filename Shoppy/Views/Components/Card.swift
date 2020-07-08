//
//  Card.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct Card: View {
    @State public var title: String
    @Binding public var value: Double
    @State public var ext: String
    @State public var specifier: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                
                Text("\(value, specifier: specifier)")
                    .font(.title)
                    .bold()
                + Text(ext)
                    .font(.footnote)
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .padding([.leading, .trailing])
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(title: "Revenue",
             value: .constant(Double(10)),
             ext: "€",
             specifier: "%.2f")
    }
}
