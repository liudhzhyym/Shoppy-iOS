//
//  UserView.swift
//  Shoppy
//
//  Created by Victor Lourme on 06/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Settings

struct UserView: View {
    @State public var network: NetworkObserver
    @State public var settings: Settings
    @State public var image: Data?
    @State private var showSettings = false
    
    var profileImage: some View {
        Image(uiImage: (UIImage(data: image ?? Data()) ?? UIImage(systemName: "rectangle.fill"))!)
            .resizable()
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
                
                Container {
                    ContainerField(name: "Currency".localized, value: self.settings.settings?.currency ?? "USD", icon: "dollarsign.circle.fill")
                }
                
                Container {
                    ContainerField(name: "BTC Address".localized,
                                   value: self.settings.settings?.bitcoinAddress ?? "Not linked".localized,
                                   icon: "b.circle.fill", accent: .orange)
                    ContainerField(name: "LTC Address".localized,
                                   value: self.settings.settings?.litecoinAddress ?? "Not linked".localized,
                                   icon: "l.circle.fill", accent: .orange)
                    ContainerField(name: "ETH Address".localized,
                                   value: self.settings.settings?.ethereumAddress ?? "Not linked".localized,
                                   icon: "e.circle.fill", accent: .orange)
                    ContainerField(name: "PayPal".localized,
                                   value: self.settings.settings?.paypalAddress ?? "Not linked".localized,
                                   icon: "p.circle.fill", accent: .orange)
                    ContainerField(name: "Stripe ID".localized,
                                   value: self.settings.settings?.stripeAccountId ?? "Not linked".localized,
                                   icon: "s.circle.fill", accent: .orange)
                }
                
                Text("Your profile can be changed on the website.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
                
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showSettings = true
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
            })
        }.sheet(isPresented: $showSettings) {
            SettingsView(network: self.network)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(network: NetworkObserver(key: ""), settings: Settings(), image: Data())
    }
}
