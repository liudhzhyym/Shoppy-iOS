//
//  OrderAccountView.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import KeychainSwift

struct OrderAccountView: View {
    @State public var order: Order
    
    var body: some View {
        List {
            ForEach(order.accounts ?? [], id: \.account) { account in
                Text(account.account ?? "")
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = account.account
                        }) {
                            Image(systemName: "doc.on.doc")
                            Text("Copy")
                        }
                    }
            }
        }
        .navigationBarTitle("Delivered accounts")
        .onAppear {
            // Load keychain
            let keychain = KeychainSwift()
            
            // Guard
            guard let id = self.order.id else {
                return
            }
            
            // Load data
            if let key = keychain.get("key") {
                NetworkManager
                    .prepare(token: key)
                    .target(.getOrder(id))
                    .asObject(Order.self, success: { order in
                        self.order = order
                    }, error: { error in
                        return
                    })
            }
        }
    }
}

struct OrderAccountView_Previews: PreviewProvider {
    static var previews: some View {
        OrderAccountView(order: Order())
    }
}
