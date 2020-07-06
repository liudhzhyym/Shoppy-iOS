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
    
    @State private var showAlert = false
    
    ///
    /// Check for key
    ///
    private func startupCheck() {
        // Check for key
        if let key = keychain.get("key") {
            print("[DefaultView] Exiting key detected, checking validity")
            
            // Check for network
            if !Reachability.isConnectedToNetwork() {
                showAlert = true
                return
            }
                
            // Disable
            showAlert = false
            
            // Check if key is valid
            NetworkManager
                .prepare(token: key)
                .target(.getAnalytics)
                .asObject(Analytics.self,
                          success: { analytics in
                            print("[DefaultView] Key is valid")
                }, error: { error in
                    print("[DefaultView] Exiting key is wrong, asking user")
                    self.showModal(AnyView(LoginView()))
                })
        } else {
            print("[DefaultView] No exiting key, asking user")
            showModal(AnyView(LoginView()))
        }
    }
    
    ///
    /// Show modal
    ///
    private func showModal(_ destination: AnyView) {
        let window = UIApplication.shared.windows.first
        let vc = UIHostingController(rootView: destination)
        
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
            
            OrdersView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Orders")
            }
        }
        .onAppear() {
            self.startupCheck()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Network is unreachable"), message: Text("Your device does not have Internet connection."), dismissButton: .default(Text("Retry"), action: {
                // Recheck
                self.startupCheck()
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
