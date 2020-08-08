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
import KingfisherSwiftUI

struct DashboardView: View {
    @EnvironmentObject var network: NetworkObserver
    
    @State private var settings = Settings()
    
    @State private var showUser = false
    
    @State private var currency = "$"
    
    @State private var revenuesStat: Double = 0
    @State private var ordersStat: Double = 0
    @State private var todayStat: Double = 0
    
    @State private var incomes: [Double] = []
    
    @State private var positive: Int = 0
    @State private var neutral: Int = 0
    @State private var negative: Int = 0
    
    var profileButton: some View {
        Button(action: {
            self.showUser = true
        }) {
            Group {
                if network.settings?.settings?.userAvatarURL != nil {
                    KFImage(URL(string: (network.settings?.settings?.userAvatarURL)!)!)
                        .resizable()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                }
            }
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
                            Text("Welcome back")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("\(self.settings.user?.username ?? "Username")")
                                .font(.largeTitle)
                                .bold()
                        }
                        .lineLimit(0)
                        
                        Spacer()
                        
                        self.profileButton
                    }
                    .padding([.leading, .trailing])
                    
                    LineChart()
                        .data(self.incomes)
                        .chartStyle(.init(backgroundColor: .clear, foregroundColor: [ColorGradient(.blue, .purple)]))
                        .frame(height: 150)
                }
                .padding(.top, geo.safeAreaInsets.bottom - 30)
                .background(Color(UIColor.secondarySystemBackground))
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Analytics")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .padding([.leading, .bottom, .top])
                        
                        HStack(alignment: .top) {
                            VStack {
                                DashboardStatView(title: "Total revenues",
                                                  currency: self.$currency,
                                                  value: self.$revenuesStat,
                                                  specifier: "%.2f",
                                                  icon: "chevron.down.circle.fill",
                                                  foreground: Color("PastelGreenSecondary"),
                                                  background: Color("PastelGreen"))
                                
                                DashboardStatView(title: "Today's revenues",
                                                  currency: self.$currency,
                                                  value: self.$todayStat,
                                                  specifier: "%.2f",
                                                  icon: "clock.fill",
                                                  foreground: Color("PastelOrangeSecondary"),
                                                  background: Color("PastelOrange"))
                            }
                            
                            Spacer()
                            
                            VStack {
                                DashboardStatView(title: "Total orders",
                                                  currency: .constant(""),
                                                  value: self.$ordersStat,
                                                  specifier: "%.0f",
                                                  icon: "cart.fill",
                                                  foreground: Color("PastelBlueSecondary"),
                                                  background: Color("PastelBlue"))
                            }
                        }
                        .padding([.leading, .trailing])
                        
                        Text("Feedbacks")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .padding([.leading, .top])
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                DashboardFeedbackView(label: "Positive",
                                                      value: self.$positive,
                                                      icon: "hand.thumbsup.fill",
                                                      color: .green)
                                
                                DashboardFeedbackView(label: "Neutral",
                                                      value: self.$neutral,
                                                      icon: "hand.raised.fill",
                                                      color: .orange)
                                
                                DashboardFeedbackView(label: "Negative",
                                                      value: self.$negative,
                                                      icon: "hand.thumbsdown.fill",
                                                      color: .red)
                            }
                            .padding([.leading, .trailing])
                        }
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
        }.onReceive(network.settingsUpdater) {
            // Set settings
            if let settings = self.network.settings {
                self.settings = settings
                self.currency = Currencies.getSymbol(forCurrencyCode: settings.settings?.currency ?? "USD") ?? "$"
            }
        }
        .onReceive(network.profileUpdater) {
            // Get reputation
            if let reputation = self.network.profile?.rep {
                self.positive = reputation.positive ?? 0
                self.neutral = reputation.neutral ?? 0
                self.negative = reputation.negative ?? 0
            }
        }
        .sheet(isPresented: $showUser) {
            UserView(network: self.network, settings: self.settings)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(NetworkObserver(key: ""))
    }
}
