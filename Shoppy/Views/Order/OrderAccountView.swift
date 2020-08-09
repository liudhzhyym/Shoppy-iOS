//
//  OrderAccountView.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import class SwiftyShoppy.NetworkManager
import struct SwiftyShoppy.Order
import enum SwiftyShoppy.Account

struct OrderAccountView: View {
    @EnvironmentObject var network: NetworkObserver
    @State public var id: String
    @State public var accounts: [Account?]?

    var body: some View {
        AccountListView(accounts: $accounts)
        .navigationBarTitle("Delivered accounts")
        .onAppear {
            // Load data
            NetworkManager
                .prepare(token: self.network.key)
                .target(.getOrder(self.id))
                .asObject(Order.self, success: { order in
                    self.accounts = order.accounts
                }, error: { error in
                    print(error)
                })
        }
    }
}

struct OrderAccountView_Previews: PreviewProvider {
    static var previews: some View {
        OrderAccountView(id: "")
    }
}
