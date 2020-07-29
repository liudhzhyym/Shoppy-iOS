//
//  DashboardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Settings
import struct SwiftyShoppy.Order
import SwiftUICharts

struct DashboardView: View {
    @EnvironmentObject var network: NetworkObserver
    
    @State private var image: Data?
    @State private var settings = Settings()
    
    @State private var showUser = false
    
    @State private var currency = "$"
    
    @State private var revenuesStat: Double = 0
    @State private var ordersStat: Double = 0
    @State private var todayStat: Double = 0
    
    @State private var incomes: [Double] = []
    
    func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd MMM YYYY"
        return df.string(from: Date())
    }
    
    var profileButton: some View {
        Button(action: {
            self.showUser = true
        }) {
            Image(uiImage: (UIImage(data: image ?? Data()) ?? UIImage(systemName: "rectangle.fill"))!)
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(10)
        }.buttonStyle(PlainButtonStyle())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(getDate())
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Text("Hi, \(self.settings.user?.username ?? "Username")")
                        .font(.largeTitle)
                        .bold()
                }.lineLimit(0)
                
                Spacer()
                
                profileButton
            }
            .padding([.leading, .top, .trailing])
            
            Text("Analytics")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .padding([.leading])
            
            ZStack(alignment: .topLeading) {
                Text("Incomes")
                    .font(.title)
                    .bold()
                    .padding()
                
                LineChart()
                    .data(incomes)
                    .chartStyle(.init(backgroundColor: .clear, foregroundColor: [ColorGradient(.blue, .purple)]))
            }
            .frame(height: 200)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    DashboardStatView(title: "Total revenues".localized,
                                      currency: $currency,
                                      value: $revenuesStat,
                                      specifier: "%.2f")
                    
                    Spacer()
                    
                    DashboardStatView(title: "Total orders".localized,
                                      currency: .constant(""),
                                      value: $ordersStat,
                                      specifier: "%.0f")
                    
                    Spacer()
                    
                    DashboardStatView(title: "Today revenue".localized,
                                      currency: $currency,
                                      value: $todayStat,
                                      specifier: "%.2f")
                }.padding([.leading, .trailing])
            }
            
            Text("Last orders")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .padding([.leading, .top])
            
            List {
                ForEach(self.network.orders.prefix(5), id: \.id) { (order: Order) in
                    DashboardCardView(
                        email: order.email ?? "",
                        product: order.product?.title ?? "",
                        date: order.paid_at ?? Date(),
                        price: (order.price ?? 0) * Double(order.quantity ?? 0),
                        currency: order.currency ?? "USD",
                        paid: order.delivered == 1)
                        .listRowInsets(EdgeInsets())
                }
            }
        }
        .onReceive(network.metricsUpdater) {
            // Set card data
            self.revenuesStat = self.network.totalRevenue
            self.todayStat = self.network.todayRevenue
        }
        .onReceive(network.analyticsUpdater) {
            // Set card data
            self.ordersStat = self.network.analytics?.totalOrders ?? -1
            
            // Set incomes
            if let income = self.network.analytics?.income {
                // Get keys
                let keys = income.keys.sorted(by: <)
                
                // Clear data
                self.incomes.removeAll()
                
                // Push data
                for key in keys {
                    let value = income[key]
                    self.incomes.append(value ?? 0)
                }
            }
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
        .sheet(isPresented: $showUser) {
            UserView(network: self.network, settings: self.settings, image: self.image)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(NetworkObserver(key: ""))
    }
}
