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
    @State public var is_supporter: Bool
    
    var body: some View {
        VStack(alignment: is_supporter ? .trailing : .leading) {
            Text(message)
        }
        .padding()
        .contextMenu {
            Text("Sent date: \(date.description)")
        }
        .background(is_supporter ? Color.blue : Color(UIColor.secondarySystemBackground))
        .cornerRadius(25)
        .padding([.leading, .trailing])
        .padding(.vertical, 5)
    }
}

struct QueryReplyView: View {
    @State public var message: String
    @State public var date: Date
    @State public var is_supporter: Bool
    
    var body: some View {
        HStack {
            if is_supporter {
                Spacer()
                
                QueryBubbleView(message: message, date: date, is_supporter: is_supporter)
            } else {
                QueryBubbleView(message: message, date: date, is_supporter: is_supporter)
                
                Spacer()
            }
        }
        
    }
}

struct QueryReplyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            QueryReplyView(message: "Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur Lorem Ipsur",
                           date: Date(),
                           is_supporter: false)
            
            QueryReplyView(message: "Support reply's! Support reply's! ",
                           date: Date(),
                           is_supporter: true)
        }
    }
}
