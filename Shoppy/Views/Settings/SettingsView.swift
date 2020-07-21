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
    case issues = "https://github.com/vlourme/SwiftyShoppy/issues"
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
    
    // Open link
    private func openLink(link: Links) {
        if let url = URL(string: link.rawValue) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            
            Text("API management")
                .font(.headline)
                .padding([.leading, .top])
            
            Container {
                ContainerButton(title: "Change API key".localized, icon: "lock.open.fill", function: {
                    self.changeKey()
                }, accent: .orange)
            }
            
            Text("Source code")
                .font(.headline)
                .padding([.leading, .top])
            
            Container {
                ContainerButton(title: "See the source code".localized, icon: "doc.text.fill", function: {
                    self.openLink(link: .github)
                }, accent: .orange)
                
                ContainerButton(title: "Report a bug".localized, icon: "exclamationmark.bubble.fill", function: {
                    self.openLink(link: .issues)
                }, accent: .orange)
            }
            
            Text("Information")
                .font(.headline)
                .padding([.leading, .top])
            
            Container {
                ContainerField(name: "Version".localized, value: self.version ?? "", icon: "i.circle.fill", accent: .orange)
            }
            
            Spacer()
        }.padding(.top)
            .sheet(isPresented: $displayLogin) {
                LoginView(isEdit: true, network: self.network)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(network: NetworkObserver(key: ""))
    }
}
