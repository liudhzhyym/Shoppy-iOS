//
//  AccountListView.swift
//  Shoppy
//
//  Created by Victor Lourme on 09/08/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import enum SwiftyShoppy.Account

struct AccountListView: View {
    @Binding public var accounts: [Account?]?

    var body: some View {
        List {
            Section(header: Text("\(accounts?.count ?? 0) \("accounts".localized)".uppercased())) {
                ForEach(accounts ?? [], id: \.self) { (account: Account?) in
                    Text(account?.get() ?? "")
                        .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = account?.get() ?? ""
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct AccountListView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListView(accounts: .constant([
            .account("Example")
        ]))
    }
}
