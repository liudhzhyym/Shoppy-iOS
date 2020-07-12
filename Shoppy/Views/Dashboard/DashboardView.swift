//
//  DashboardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct DashboardView: View {
    @EnvironmentObject var network: NetworkObserver
    
    @State private var image: Data?
    @State private var settings = Settings()
    @State private var displaySettings = false
    
    @State private var revenues: Double = 0
    @State private var orders: Double = 0
    @State private var today: Double = 0
    
    var profileButton: some View {
        NavigationLink(destination: UserView(settings: settings, image: image)) {
            Image(uiImage: (UIImage(data: image ?? Data()) ?? UIImage(systemName: "person"))!)
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
            VStack(alignment: .leading) {
                Text("Statistics")
                    .font(.title)
                    .bold()
                    .padding([.leading, .top])
                
                Group {
                    Card(title: "Total orders".localized,
                         value: $orders,
                         ext: "", specifier: "%.0f")
                    
                    Card(title: "Total revenue".localized,
                         value: $revenues,
                         ext: "€", specifier: "%.2f")
                    
                    Card(title: "Daily income".localized,
                         value: $today,
                         ext: "€", specifier: "%.2f")
                }.padding(.vertical, 5)
                
                Text("Navigation")
                    .font(.title)
                    .bold()
                    .padding([.leading, .top])
                
                Container {
                    ContainerNavigationButton(title: "Queries".localized,
                                              icon: "envelope",
                                              destination: AnyView(QueriesView()))
                }
                
                Spacer()
            }
                
            .navigationBarTitle("Dashboard")
            .navigationBarItems(leading: profileButton, trailing: settingsButton)
        }
        .onReceive(network.metricsUpdater) {
            // Set card data
            self.revenues = self.network.totalRevenue
            self.today = self.network.todayRevenue
        }
        .onReceive(network.analyticsUpdater) {
            // Set card data
            self.orders = self.network.analytics?.totalOrders ?? -1
        }.onReceive(network.settingsUpdater) {
            // Set settings
            if let settings = self.network.settings {
                self.settings = settings
            }
        }
        .onReceive(network.imageUpdater) {
            // Set image
            if let image = self.network.image {
                self.image = image
            }
        }
        .sheet(isPresented: $displaySettings) {
            SettingsView(network: self.network)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
