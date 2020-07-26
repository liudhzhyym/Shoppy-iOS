//
//  ProductAccountView.swift
//  Shoppy
//
//  Created by Victor Lourme on 10/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import enum SwiftyShoppy.Account

struct ProductAccountView: View {
    @State public var accounts: [Account?]?
    
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
        .navigationBarTitle("Accounts")
    }
}

struct ProductAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductAccountView(accounts: [
                .account("email@domain.tld"),
                .account("email2@domain.tld"),
                .account("email3@domain.tld")
            ])
        }
    }
}
