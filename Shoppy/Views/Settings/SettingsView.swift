//
//  SettingsView.swift
//  Shoppy
//
//  Created by Victor Lourme on 03/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

enum Links: String {
    case github = "https://github.com/vlourme/Shoppy-iOS"
    case issues = "https://github.com/vlourme/Shoppy-iOS/issues"
}

struct SettingsView: View {
    // Sheet login
    @State private var displayLogin = false
    
    // EnvironmentObject workaround for sheet modals
    @State public var network: NetworkObserver
    
    // Version name
    @State private var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    // Change key
    private func changeKey() {
        self.displayLogin = true
    }
    
    // Safari WebView
    @State private var url: Links = .github
    @State private var showSafari = false
    
    // Donation
    @State private var showDonation = false
    @State private var showError = false
    
    var body: some View {
            List {
                Section(header: Text("API management")) {
                    NavigationLink(destination: LoginView(isEdit: true, network: self.network)) {
                        Label(label: "Change API key", icon: "lock.open.fill", color: .red)
                    }
                }
                
                Section(header: Text("Source code")) {
                    Button(action: {
                        self.url = .github
                        self.showSafari.toggle()
                    }) {
                        Label(label: "See the source code", showChevron: true, icon: "doc.text.fill")
                    }
                    
                    Button(action: {
                        self.url = .issues
                        self.showSafari.toggle()
                    }) {
                        Label(label: "Report a bug", showChevron: true, icon: "exclamationmark.bubble.fill")
                    }
                }.buttonStyle(PlainButtonStyle())
                
                Section(header: Text("Donations")) {
                    Button(action: {
                        SwiftyStoreKit.purchaseProduct("SM_TIP", quantity: 1, atomically: true) { result in
                            switch result {
                                case .success:
                                    self.showDonation.toggle()
                                case .error:
                                    self.showError.toggle()
                            }
                        }
                    }) {
                        Label(label: "Donate $1", showChevron: true, icon: "1.circle.fill", color: .green)
                    }
                    
                    Button(action: {
                        SwiftyStoreKit.purchaseProduct("MD_TIP", quantity: 1, atomically: true) { result in
                            switch result {
                                case .success:
                                    self.showDonation.toggle()
                                case .error:
                                    self.showError.toggle()
                            }
                        }
                    }) {
                        Label(label: "Donate $3", showChevron: true, icon: "3.circle.fill", color: .green)
                    }
                }.buttonStyle(PlainButtonStyle())
                
                Section(header: Text("Information")) {
                    Label(label: "Version", value: self.version ?? "", icon: "i.circle.fill", color: .orange)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
        .alert(isPresented: $showDonation) {
            Alert(title: Text("Thank you!"),
                  message: Text("Thank you so much for donating, it's so nice 🥰"),
                  dismissButton: .default(Text("Close")))
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"),
                  message: Text("Hm, there was an error..."),
                  dismissButton: .cancel())
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: self.url.rawValue)!)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(network: NetworkObserver(key: ""))
    }
}
