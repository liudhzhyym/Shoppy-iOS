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
    
    @State private var modalContent = AnyView(EmptyView())
    @State private var showModal = false
    
    @State private var currency = "$"
    
    @State private var revenuesStat: Double = 0
    @State private var ordersStat: Double = 0
    @State private var todayStat: Double = 0
    
    var profileButton: some View {
        Button(action: {
            self.modalContent = AnyView(UserView(settings: self.settings, image: self.image))
            self.showModal = true
        }) {
            HStack {
            Image(uiImage: (UIImage(data: image ?? Data()) ?? UIImage(systemName: "person"))!)
                .renderingMode(.original)
                .resizable()
                .frame(width: 26, height: 26)
                .clipShape(Circle())
                
                Text(self.network.settings?.user?.username ?? "")
                        .font(.headline)
                }
        }
    }
    
    var queriesButton: some View {
        Button(action: {
            self.modalContent = AnyView(QueriesView(network: self.network))
            self.showModal = true
        }) {
            Image(systemName: "bubble.left")
                .imageScale(.large)
        }
    }
    
    var settingsButton: some View {
        Button(action: {
            self.modalContent = AnyView(SettingsView(network: self.network))
            self.showModal = true
        }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .foregroundColor(.white)
        }
    }
    
    var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            ZStack(alignment: .top) {
                ScrollView {
                    Spacer()
                    
                    ForEach(self.network.orders.prefix(10), id: \.id) { (order: Order) in
                        Group {
                            DashboardCardView(email: order.email ?? "",
                                              product: order.product?.title ?? "",
                                              date: order.created_at ?? Date(),
                                              price: (order.price ?? 0) * Double(order.quantity ?? 0),
                                              currency: order.currency ?? "USD",
                                              paid: order.delivered == 1)
                            Divider()
                        }
                    }
                }
                .id(UUID().uuidString)
                .font(.system(.body, design: .rounded))
                .padding(.top, 300)
                
                VStack {
                    HStack {
                        self.profileButton
                        
                        Spacer()
                        
                        Group {
                            self.queriesButton
                            
                            self.settingsButton
                        }.padding(.leading)
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            DashboardStatView(title: "Today's earnings", currency: self.$currency, value: self.$todayStat, specifier: "%.2f")
                            
                            DashboardStatView(title: "Total earnings", currency: self.$currency, value: self.$revenuesStat, specifier: "%.2f")
                            
                            DashboardStatView(title: "Total orders", currency: .constant(""), value: self.$ordersStat, specifier: "%.0f")
                        }.padding()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("10 last orders")
                        
                        Spacer()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                }
                .padding()
                .padding(.top, proxy.safeAreaInsets.top)
                .frame(height: 300)
                .background(Image("Pattern").resizable(resizingMode: .tile))
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onReceive(network.metricsUpdater) {
            // Set card data
            self.revenuesStat = self.network.totalRevenue
            self.todayStat = self.network.todayRevenue
        }
        .onReceive(network.analyticsUpdater) {
            // Set card data
            self.ordersStat = self.network.analytics?.totalOrders ?? -1
        }.onReceive(network.settingsUpdater) {
            // Set settings
            if let settings = self.network.settings {
                self.settings = settings
                self.currency = Currencies.getSymbol(forCurrencyCode: settings.settings?.currency ?? "USD") ?? "$"
            }
        }
        .onReceive(network.imageUpdater) {
            // Set image
            if let image = self.network.image {
                self.image = image
            }
        }
        .sheet(isPresented: $showModal) {
            self.modalContent
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
