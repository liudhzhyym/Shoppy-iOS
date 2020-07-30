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
    @State private var gateways: [String: Double] = [:]
    
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
                .frame(width: 56, height: 56)
                .clipShape(Circle())
        }.buttonStyle(PlainButtonStyle())
    }
    
    var body: some View {
        GeometryReader { (geo: GeometryProxy) in
            VStack(alignment: .leading, spacing: 0) {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(self.getDate())
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("Hi, \(self.settings.user?.username ?? "Username")")
                                .font(.largeTitle)
                                .bold()
                        }.lineLimit(0)
                        
                        Spacer()
                        
                        self.profileButton
                    }
                    .padding([.leading, .trailing])
                    
                    LineChart()
                        .data(self.incomes)
                        .chartStyle(.init(backgroundColor: .clear, foregroundColor: [ColorGradient(.blue, .purple)]))
                        .frame(height: 150)
                }
                .padding(.top, geo.safeAreaInsets.top)
                .background(Color(UIColor.secondarySystemBackground))
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Gateways")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .padding([.leading, .top])
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(self.gateways.sorted(by: >), id: \.key) { key, value in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(key.uppercased())
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                            
                                            Text("\(value, specifier: "%.0f")")
                                                .font(.system(size: 20))
                                                .bold()
                                        }
                                        .lineLimit(0)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(width: 175)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(20)
                                }
                                .id(UUID())
                                .padding(.trailing, 10)
                            }.padding([.leading, .trailing])
                        }
                        
                        Text("Analytics")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .padding([.leading, .bottom])
                        
                        HStack(alignment: .top) {
                            VStack {
                                DashboardStatView(title: "Total revenues".localized,
                                                  currency: self.$currency,
                                                  value: self.$revenuesStat,
                                                  specifier: "%.2f",
                                                  icon: "chevron.down.circle.fill",
                                                  foreground: Color("PastelGreenSecondary"),
                                                  background: Color("PastelGreen"))
                                
                                DashboardStatView(title: "Today's revenues".localized,
                                                  currency: self.$currency,
                                                  value: self.$todayStat,
                                                  specifier: "%.2f",
                                                  icon: "clock.fill",
                                                  foreground: Color("PastelOrangeSecondary"),
                                                  background: Color("PastelOrange"))
                            }
                            
                            Spacer()
                            
                            VStack {
                                DashboardStatView(title: "Total orders".localized,
                                                  currency: .constant(""),
                                                  value: self.$ordersStat,
                                                  specifier: "%.0f",
                                                  icon: "cart.fill",
                                                  foreground: Color("PastelBlueSecondary"),
                                                  background: Color("PastelBlue"))
                            }
                        }
                        .padding([.leading, .trailing])
                    }.padding(.bottom)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
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
            
            // Clear gateways
            self.gateways.removeAll()
            
            // Set gateways
            if let gateways = self.network.analytics?.gateways {
                self.gateways = gateways
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
