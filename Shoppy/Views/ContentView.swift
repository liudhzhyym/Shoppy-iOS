//
//  ContentView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import KeychainSwift
import SwiftyShoppy

struct ContentView: View {
    // Keychain
    private let keychain = KeychainSwift()
    
    ///
    /// Check for key
    ///
    private func startupCheck() {
        // Check for key
        if let key = keychain.get("key") {
            print("[DefaultView] Exiting key detected, checking validity")
            
            // Check if key is valid
            let nm = NetworkManager(token: key)
            nm.getAnalytics() { _, error in
                if error != nil {
                    print("[DefaultView] Exiting key is wrong, asking user")
                    self.showModal()
                }
                
                print("[DefaultView] Key is valid")
            }
        } else {
            print("[DefaultView] No exiting key, asking user")
            showModal()
        }
        
    }
    
    ///
    /// Show modal
    ///
    private func showModal() {
        let window = UIApplication.shared.windows.first
        let vc = UIHostingController(rootView: LoginView())
        
        // Disable dismiss gesture
        vc.isModalInPresentation = true
        
        // Display
        window?.rootViewController?.present(vc, animated: true)
    }
    
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }
        }
        .onAppear() {
            self.startupCheck()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
