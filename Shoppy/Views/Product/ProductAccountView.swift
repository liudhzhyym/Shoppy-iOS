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
            if accounts != nil {
                Section(header: Text("\(accounts!.count) \("accounts".localized)".uppercased())) {
                    ForEach(0 ..< accounts!.count) { idx in
                        Text(self.accounts?[idx]?.get() ?? "")
                            .contextMenu {
                                Button(action: {
                                    UIPasteboard.general.string = self.accounts?[idx]?.get() ?? ""
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy")
                                }
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
