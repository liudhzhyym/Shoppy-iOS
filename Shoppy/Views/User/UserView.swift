//
//  UserView.swift
//  Shoppy
//
//  Created by Victor Lourme on 06/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Settings
import KingfisherSwiftUI

struct UserView: View {
    @State public var network: NetworkObserver
    @State public var settings: Settings
    @State private var showSettings = false
    
    var profileImage: some View {
        Group {
            if network.settings?.settings?.userAvatarURL != nil {
                KFImage(URL(string: (network.settings?.settings?.userAvatarURL)!)!)
                    .resizable()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
            }
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    profileImage
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(settings.user?.username ?? "Username")
                            .font(.largeTitle)
                            .bold()
                        
                        Text(settings.user?.email ?? "email@domain.tld")
                            .font(.headline)
                    }
                    .lineLimit(0)
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                List {
                    Section(header: Text("Account")) {
                        Label(label: "Currency",
                              value: self.settings.settings?.currency ?? "USD",
                              icon: "dollarsign.circle.fill")
                    }
                    
                    Section(header: Text("Payments")) {
                        Label(label: "BTC Address",
                              value: self.settings.settings?.bitcoinAddress ?? "N/A",
                              icon: "b.circle.fill",
                              color: .orange)
                        
                        Label(label: "LTC Address",
                              value: self.settings.settings?.litecoinAddress ?? "N/A",
                              icon: "l.circle.fill",
                              color: .orange)
                        
                        Label(label: "ETH Address",
                              value: self.settings.settings?.ethereumAddress ?? "N/A",
                              icon: "e.circle.fill",
                              color: .orange)
                        
                        Label(label: "PayPal",
                              value: self.settings.settings?.paypalAddress ?? "N/A",
                              icon: "p.circle.fill",
                              color: .orange)
                        
                        Label(label: "Stripe ID",
                              value: self.settings.settings?.stripeAccountId ?? "N/A",
                              icon: "s.circle.fill",
                              color: .orange)
                    }
                    
                    Section(header: Text("Customers")) {
                        NavigationLink(destination: FeedbackView(network: self.network)) {
                            Label(label: "See feedbacks", icon: "hand.thumbsup.fill", color: .green)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                Text("Your profile can be changed on the website.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
                
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView(network: self.network)) {
                Image(systemName: "gear")
                    .imageScale(.large)
            })
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(network: NetworkObserver(key: ""), settings: Settings())
    }
}
