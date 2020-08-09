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
    @State private var showOnboard = true

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

            QueriesView()
                .tabItem {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                    Text("Support")
            }
        }
        .onReceive(network.analyticsUpdater) {
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                self.showOnboard = false
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
        .onboard(isPresented: $showOnboard)
        .networkAlert(isPresented: $showAlert, network: self.network)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
