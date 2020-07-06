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
    @State private var settings = Settings()
    @ObservedObject private var image = ImageLoader()
    @State private var displaySettings = false
    @State private var dailyIncome = 0
    @State private var totalRevenue = 0
    @State private var orders = 0
    
    private func loadUser() {
        // Load keychain
        let keychain = KeychainSwift()
        
        // Load data
        if let key = keychain.get("key") {
            // Load settings
            NetworkManager
                .prepare(token: key)
                .target(.getSettings)
                .asObject(Settings.self, success: { settings in
                    // Store settings
                    self.settings = settings
                    
                    // Load image
                    if let url = settings.settings?.userAvatarURL {
                        print(url)
                        self.image.setImage(imageURL: url)
                    }
                }, error: { error in
                    print(error)
                })
            
            // Load stats
            NetworkManager
                .prepare(token: key)
                .target(.getAnalytics)
                .asObject(Analytics.self, success: { analytics in
                    self.orders = analytics.totalOrders ?? 0
                    self.dailyIncome = analytics.todaysRevenue ?? 0
                    self.totalRevenue = analytics.totalRevenue ?? 0
                }, error: { error in
                    print(error)
                })
        }
    }
    
    var profileButton: some View {
        NavigationLink(destination: UserView(settings: settings, image: image)) {
            Image(uiImage: ((image.image != nil) ?
                UIImage(data: image.image!): UIImage(systemName: "person"))!)
                .resizable()
                .frame(width: 26, height: 26)
                .clipShape(Circle())
        }.buttonStyle(PlainButtonStyle())
    }
    
    var settingsButton: some View {
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
            .navigationBarItems(leading: profileButton, trailing: settingsButton)
        }.onAppear() {
            self.loadUser()
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
