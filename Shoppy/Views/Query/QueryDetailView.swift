//
//  QueryDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import KeyboardObserving

struct QueryDetailView: View {
    @EnvironmentObject var network: NetworkObserver
    
    @State public var query: Query
    @State private var showButton = false
    @State private var message = TextFieldLength(limit: 255)
    
    private func sendMessage() {
        if message.text.count < 2 {
            return
        }
        
        guard let id = query.id else {
            return
        }
        
        // Send
        NetworkManager
            .prepare(token: network.key)
            .target(.replyToQuery(id, message: message.text))
            .asObject(ResourceUpdate<Query>.self, success: { update in
                if update.status == true {
                    if let query = update.resource {
                        self.query = query
                    }
                } else {
                    print(update.message ?? "")
                }
            }, error: { error in
                print(error)
            })
        
        // Empty the message
        message.text = ""
    }
    
    var body: some View {
        VStack {
            ScrollView {
                QueryReplyView(message: query.message ?? "", date: query.created_at ?? Date(), is_supporter: false)
                
                ForEach(query.replies?.reversed() ?? [], id: \.id) { (reply: QueryReply) in
                    QueryReplyView(message: reply.message ?? "", date: reply.created_at ?? Date(), is_supporter: reply.is_supporter ?? false)
                }
            }
            
            .navigationBarTitle(query.subject ?? "Query")
            
            if query.status != QueryStatus.Closed.rawValue {
                HStack {
                    TextField("Tap to reply", text: $message.text)
                    
                    if showButton {
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .accentColor(.orange)
                        }
                    }
                }
                .onReceive(message.subscriber) {
                    if self.message.text.count > 1 && self.message.text.count < 255 {
                        withAnimation {
                            self.showButton = true
                        }
                    } else {
                        self.showButton = false
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
            }
        }.keyboardObserving()
    }
}

struct QueryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QueryDetailView(query: Query())
    }
}
