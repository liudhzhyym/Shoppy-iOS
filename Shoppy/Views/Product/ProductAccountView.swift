//
//  ProductAccountView.swift
//  Shoppy
//
//  Created by Victor Lourme on 10/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct ProductAccountView: View {
    @State public var accounts: [Account?]?
    
    var body: some View {
        List {
            if accounts != nil {
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
        .navigationBarTitle("Accounts", displayMode: .inline)
    }
}

struct ProductAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProductAccountView(accounts: [.account("test")])
    }
}
