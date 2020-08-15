//
//  FeedbackCardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 29/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Feedback

struct FeedbackCardView: View {
    @State public var feedback: Feedback

    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd"

        return df.string(from: date)
    }

    var body: some View {
        HStack(spacing: 15) {
            if feedback.rating == -1 {
                Image(systemName: "hand.thumbsdown.fill")
                    .foregroundColor(Color("PastelRedSecondary"))
                    .font(.headline)
                    .padding(14)
                    .frame(width: 40, height: 40)
                    .background(Circle().foregroundColor(Color("PastelRed")))
            } else if feedback.rating == 0 {
                 Image(systemName: "hand.raised.fill")
                    .foregroundColor(Color("PastelOrangeSecondary"))
                    .font(.headline)
                    .padding(14)
                    .frame(width: 40, height: 40)
                    .background(Circle().foregroundColor(Color("PastelOrange")))
            } else {
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor(Color("PastelGreenSecondary"))
                    .font(.headline)
                    .padding(14)
                    .frame(width: 40, height: 40)
                    .background(Circle().foregroundColor(Color("PastelGreen")))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(feedback.comment ?? "Unknown comment")

                Text("\(feedback.stars ?? 0) stars - \(getDate(date: feedback.created_at ?? Date()))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .bold()
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
}

struct FeedbackCardView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FeedbackCardView(feedback: Feedback())
                .listRowInsets(EdgeInsets())

            FeedbackCardView(feedback: Feedback())
                .listRowInsets(EdgeInsets())
        }.listStyle(GroupedListStyle())
    }
}
