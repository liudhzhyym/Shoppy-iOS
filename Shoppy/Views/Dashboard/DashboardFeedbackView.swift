//
//  DashboardFeedbackView.swift
//  Shoppy
//
//  Created by Victor Lourme on 31/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct DashboardFeedbackView: View {
    @State public var label: String
    @Binding public var value: Int
    @State public var icon: String
    @State public var color: Color

    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundColor(color)
                .padding(.leading, 5)

            VStack(alignment: .leading) {
                Text(label.localized.uppercased())
                    .font(.footnote)
                    .foregroundColor(.secondary)

                Text("\(value)")
                    .font(.system(size: 24))
                    .bold()
            }

            Spacer()
        }
        .padding()
        .frame(width: 200)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .padding(.trailing)
    }
}

struct DashboardFeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardFeedbackView(label: "Positive", value: .constant(50), icon: "hand.thumbsup.fill", color: .green)
    }
}
