//
//  QueryReplyView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct QueryBubbleView: View {
    @State public var message: String
    @State public var date: Date
    @State public var isSupporter: Bool

    var body: some View {
        VStack(alignment: isSupporter ? .trailing : .leading) {
            Text(message)
        }
        .padding()
        .padding(.horizontal, 4)
        .contextMenu {
            Text("Sent date: \(date.description)")
        }
        .background(isSupporter ? Color.blue : Color(UIColor.secondarySystemBackground))
        .cornerRadius(20, corners: isSupporter ? [.topLeft, .topRight, .bottomLeft] : [.topRight, .bottomLeft, .bottomRight])
        .cornerRadius(5, corners: isSupporter ? .bottomRight : .topLeft)
        .padding([.leading, .trailing])
        .padding(.vertical, 5)
    }
}

struct QueryReplyView: View {
    @State public var message: String
    @State public var date: Date
    @State public var isSupporter: Bool

    var body: some View {
        HStack {
            if isSupporter {
                Spacer()

                QueryBubbleView(message: message, date: date, isSupporter: isSupporter)
            } else {
                QueryBubbleView(message: message, date: date, isSupporter: isSupporter)

                Spacer()
            }
        }

    }
}

struct QueryReplyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Long message from client
            QueryReplyView(message: "Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur",
                           date: Date(),
                           isSupporter: false)

            // Normal message
            QueryReplyView(message: "Support reply's! Support reply's! ",
                           date: Date(),
                           isSupporter: true)

            // Short message
            QueryReplyView(message: "Ok man",
                           date: Date(),
                           isSupporter: true)

            // Very short message
            QueryReplyView(message: "Ok!",
                           date: Date(),
                           isSupporter: true)
        }
    }
}
