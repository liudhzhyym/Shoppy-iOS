//
//  QueryDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Query
import struct SwiftyShoppy.QueryReply
import struct SwiftyShoppy.ResourceUpdate
import enum SwiftyShoppy.QueryStatus
import class SwiftyShoppy.NetworkManager
import KeyboardObserving

struct QueryDetailView: View {
    @EnvironmentObject var network: NetworkObserver
    
    @State public var query: Query
    @State private var showButton = false
    @State private var showDetail = false
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
                    // Update query
                    if let query = update.resource {
                        self.query = query
                    }
                    
                    // Update list
                    self.network.getQueries(page: 1)
                } else {
                    print(update.message ?? "")
                }
            }, error: { error in
                print(error)
            })
        
        // Empty the message
        message.text = ""
    }
    
    var detail: some View {
        Button(action: {
            self.showDetail = true
        }) {
            Image(systemName: "person.crop.circle.fill")
                .imageScale(.large)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                Spacer()
                
                QueryReplyView(message: query.message ?? "", date: query.created_at ?? Date(), is_supporter: false)
                
                ForEach(query.replies?.reversed() ?? [], id: \.id) { (reply: QueryReply) in
                    QueryReplyView(message: reply.message ?? "", date: reply.created_at ?? Date(), is_supporter: reply.is_supporter ?? false)
                }
                
                Spacer(minLength: 100)
            }
            
            if query.status != QueryStatus.Closed.rawValue {
                HStack {
                    TextField("Tap to reply", text: $message.text.animation())
                    
                    if showButton {
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .font(.headline)
                                .foregroundColor(Color("PastelGreenSecondary"))
                        }
                        .animation(.default)
                        .transition(.slide)
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
                .padding(22)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(20)
                .padding()
            }
        }
        .navigationBarTitle("\(query.subject ?? "Query")", displayMode: .inline)
        .navigationBarItems(trailing: detail)
        .keyboardObserving()
        .sheet(isPresented: $showDetail) {
            QuerySheetView(network: self.network, query: self.$query, token: self.network.key)
        }
    }
}

struct QueryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QueryDetailView(query: Query())
    }
}
