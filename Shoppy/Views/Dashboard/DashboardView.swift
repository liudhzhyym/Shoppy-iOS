//
//  DashboardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import KeychainSwift

struct DashboardView: View {
    @State private var displaySettings = false
    @State private var dailyIncome = 0
    @State private var totalRevenue = 0
    @State private var orders = 0
    
    private func loadStats() {
        // Load keychain
        let keychain = KeychainSwift()
        
        // Instance NetworkManager
        let nm = NetworkManager(token: keychain.get("key") ?? "")
        
        // Get analytics
        nm.getAnalytics() { analytics, error in
            if error != nil {
                // Catch
                return
            }
            
            // Set data
            self.orders = analytics?.totalOrders ?? 0
            self.dailyIncome = analytics?.todaysRevenue ?? 0
            self.totalRevenue = analytics?.totalRevenue ?? 0
        }
    }
    
    var settings: some View {
        Button(action: {
            self.displaySettings = true
        }) {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 26, height: 26)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    Card(title: "Total revenue", value: $totalRevenue, ext: "€")
                    
                    Card(title: "Daily income", value: $dailyIncome, ext: "€")
                    
                    Card(title: "Total orders", value: $orders, ext: "")
                    
                }.padding([.top, .bottom], 5)
                Spacer()
            }
                
            .navigationBarTitle("Dashboard")
            .navigationBarItems(trailing: settings)
        }.onAppear() {
            self.loadStats()
        }.sheet(isPresented: $displaySettings) {
            SettingsView()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
