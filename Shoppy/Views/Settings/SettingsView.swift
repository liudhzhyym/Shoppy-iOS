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
    @State private var displayLogin = false
    
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
        NavigationView {
            VStack {
                Container {
                    ContainerButton(title: "Change API key", icon: "lock.open.fill", function: {
                        self.changeKey()
                    }, accent: .orange)
                }
                
                Container {
                    ContainerButton(title: "See the source code", icon: "doc.text.fill", function: {
                        self.openLink(link: .github)
                    }, accent: .orange)
                    
                    ContainerButton(title: "Report a bug", icon: "exclamationmark.bubble.fill", function: {
                        self.openLink(link: .issues)
                    }, accent: .orange)
                }
                
                Container {
                    ContainerField(name: "Version", value: "1.0", icon: "i.circle.fill", accent: .orange)
                }
                
                Spacer()
            }.padding(.top)
                
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
