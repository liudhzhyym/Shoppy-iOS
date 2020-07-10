//
//  ContentView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: NetworkObserver
    @State private var showAlert = false
    
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
            
            ProductView()
                .tabItem {
                    Image(systemName: "cube.box")
                    Text("Products")
            }
        }
        .onReceive(network.errorSubscriber) {
            // Check for network
            if !Reachability.isConnectedToNetwork() {
                self.showAlert = true
                return
            }
            
            self.showModal(AnyView(LoginView(network: self.network)))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Network is unreachable"),
                  message: Text("Your device does not have Internet connection, reload the application when you have connection back."),
                  dismissButton: .cancel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
