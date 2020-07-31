//
//  SettingsView.swift
//  Shoppy
//
//  Created by Victor Lourme on 03/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

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
    
    // Safari WebView
    @State private var url: Links = .github
    @State private var showSafari = false
    
    ///
    /// Change key
    ///
    private func changeKey() {
        self.displayLogin = true
    }
    
    ///
    /// Body
    ///
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
                NavigationLink(destination: DonationView()) {
                    Label(label: "Make a donation", icon: "app.gift.fill", color: .green)
                }
            }
            
            Section(header: Text("Information")) {
                Label(label: "Version", value: self.version ?? "", icon: "i.circle.fill", color: .orange)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Settings", displayMode: .inline)
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
