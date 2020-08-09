//
//  HighlightCardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 22/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct HighlightCardView: View {
    @State public var name: String
    @State public var value: String
    @State public var icon: String
    @State public var foreground: Color
    @State public var background: Color

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .font(.system(size: 36))

            Spacer()

            Text(name.localized.uppercased())
                .font(.footnote)

            Text(value)
                .font(.title)
                .bold()
        }
        .padding()
        .foregroundColor(foreground)
        .frame(width: 150, height: 150, alignment: .topLeading)
        .background(background)
        .cornerRadius(20)
    }
}

struct HighlightCardView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightCardView(name: "Earnings",
                           value: "$ 300",
                           icon: "creditcard.fill",
                           foreground: Color("PastelGreenSecondary"),
                           background: Color("PastelGreen"))
    }
}
