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
            .sheet(isPresented: $displayLogin) {
                LoginView(isEdit: true, network: self.network)
            }
            
            Text("Source code")
                .font(.headline)
                .padding([.leading, .top])
            
            Container {
                ContainerButton(title: "See the source code".localized, icon: "doc.text.fill", function: {
                    self.url = .github
                    self.showSafari.toggle()
                }, accent: .orange)
                
                ContainerButton(title: "Report a bug".localized, icon: "exclamationmark.bubble.fill", function: {
                    self.url = .issues
                    self.showSafari.toggle()
                }, accent: .orange)
            }
            .sheet(isPresented: $showSafari) {
                SafariView(url: URL(string: self.url.rawValue)!)
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            Text("Donation")
                .font(.headline)
                .padding([.leading, .top])
            
            Container {
                ContainerButton(title: "Donate $1", icon: "1.circle.fill", function: {
                    SwiftyStoreKit.purchaseProduct("SM_TIP", quantity: 1, atomically: true) { result in
                        switch result {
                            case .success:
                                self.showDonation.toggle()
                            case .error:
                                self.showError.toggle()
                        }
                    }
                })
                
                ContainerButton(title: "Donate $3", icon: "3.circle.fill", function: {
                    SwiftyStoreKit.purchaseProduct("MD_TIP", quantity: 1, atomically: true) { result in
                        switch result {
                            case .success:
                                self.showDonation.toggle()
                            case .error:
                                self.showError.toggle()
                        }
                    }
                })
            }
            
            Text("Information")
                .font(.headline)
                .padding([.leading, .top])
            
            Container {
                ContainerField(name: "Version".localized, value: self.version ?? "", icon: "i.circle.fill", accent: .orange)
            }
            
            Spacer()
        }
        .padding(.top)
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(network: NetworkObserver(key: ""))
    }
}
