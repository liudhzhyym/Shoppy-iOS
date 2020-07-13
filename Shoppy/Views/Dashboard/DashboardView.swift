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
                .renderingMode(.original)
                .resizable()
                .frame(width: 26, height: 26)
                .clipShape(Circle())
        }
    }
    
    var settingsButton: some View {
        Button(action: {
            self.displaySettings = true
        }) {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundColor(.white)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    VStack {
                        Text("\(self.revenues, specifier: "%.2f")")
                            .font(.title)
                            .bold()
                            + Text(Currencies.getSymbol(forCurrencyCode: self.network.settings?.settings?.currency ?? "USD") ?? "$")
                                .font(.callout)
                        Text("Total income")
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("\(self.today, specifier: "%.2f")")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                    + Text(Currencies.getSymbol(forCurrencyCode: self.network.settings?.settings?.currency ?? "USD") ?? "$")
                                        .font(.callout)
                                Text("Today income")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("\(self.orders, specifier: "%.0f")")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold)
                                Text("Orders")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding(.top, proxy.safeAreaInsets.top)
                    .padding()
                    .frame(height: 320)
                    .foregroundColor(.white)
                        .background(LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).opacity(0.9))
                    .cornerRadius(30)
                    .shadow(radius: 6)
                    
                    Container {
                        ContainerNavigationButton(title: "Queries".localized,
                                                  icon: "bubble.left.and.bubble.right.fill",
                                                  destination: AnyView(QueriesView()))
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.top)
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
