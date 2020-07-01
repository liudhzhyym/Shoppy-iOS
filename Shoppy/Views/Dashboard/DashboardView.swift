//
//  DashboardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftUICharts
import SwiftyShoppy
import KeychainSwift

struct DashboardView: View {
    @State private var data: [Double] = []
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
            
            // Set orders
            self.orders = analytics?.totalOrders ?? 0
            
            // Sort incomes
            let keys = analytics?.income?.keys.sorted(by: <)
            
            // Clear data
            self.data.removeAll()
            
            // Push
            for key in keys! {
                let i = analytics?.income?[key]
                self.data.append(Double(i ?? 0))
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                LineChartView(data: data,
                              title: "Revenues",
                              form: ChartForm.extraLarge,
                              rateValue: 0,
                              valueSpecifier: "%0.2f€")
                
                Card(title: "Total orders", value: $orders, ext: "").padding()
                
                Spacer()
            }.padding(.top)
                
            .navigationBarTitle("Dashboard")
        }.onAppear() {
            self.loadStats()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
