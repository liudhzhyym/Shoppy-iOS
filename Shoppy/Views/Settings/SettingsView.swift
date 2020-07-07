//
//  SettingsView.swift
//  Shoppy
//
//  Created by Victor Lourme on 03/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var displayLogin = false
    @State private var credits = [
        "SwiftyShoppy": "https://github.com/vlourme/SwiftyShoppy",
        "Moya": "https://github.com/Moya/Moya",
        "KeychainSwift": "https://github.com/evgenyneu/keychain-swift"
    ]
    
    // Change key
    private func changeKey() {
        self.displayLogin = true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API")) {
                    Button(action: changeKey) {
                        HStack(spacing: 10) {
                            Image(systemName: "lock.fill")
                            Text("Change API key")
                        }
                    }
                }
                
                Section(header: Text("Source code")) {
                    Button(action: {
                        if let url = URL(string: "https://github.com/vlourme/Shoppy-iOS/issues") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.bubble.fill")
                            Text("Report an issue")
                        }
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/vlourme/Shoppy-iOS") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "doc.text.fill")
                            Text("View the source code on GitHub")
                        }
                    }
                }
                
                Section(header: Text("Libraries used")) {
                    List {
                        ForEach(credits.sorted(by: >), id: \.key) { name, url in
                            Button(action: {
                                if let url = URL(string: url) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text(name)
                            }
                        }
                    }
                }
            }
                
            .navigationBarTitle("Settings", displayMode: .inline)
        }.sheet(isPresented: $displayLogin) {
            LoginView(isEdit: true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
