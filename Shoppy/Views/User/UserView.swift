//
//  UserView.swift
//  Shoppy
//
//  Created by Victor Lourme on 06/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct UserView: View {
    @State public var settings: Settings
    @State public var image: Data?
    
    var body: some View {
        VStack {
            Group {
                VStack {
                    Image(uiImage: (UIImage(data: image ?? Data()) ?? UIImage(systemName: "person"))!)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Text(settings.user?.username ?? "Username")
                        .font(.title)
                        .bold()
                    
                    Text(settings.user?.email ?? "email@provider.tld")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }.padding(.vertical)
            
            
            Container {
                ContainerField(name: "BTC Address",
                               value: self.settings.settings?.bitcoinAddress ?? "Not linked",
                               icon: "b.circle.fill", accent: .orange)
                ContainerField(name: "LTC Address",
                               value: self.settings.settings?.litecoinAddress ?? "Not linked",
                               icon: "l.circle.fill", accent: .orange)
                ContainerField(name: "ETH Address",
                               value: self.settings.settings?.ethereumAddress ?? "Not linked",
                               icon: "e.circle.fill", accent: .orange)
                ContainerField(name: "PayPal",
                               value: self.settings.settings?.paypalAddress ?? "Not linked",
                               icon: "p.circle.fill", accent: .orange)
                ContainerField(name: "Stripe ID",
                               value: self.settings.settings?.stripeAccountId ?? "Not linked",
                               icon: "s.circle.fill", accent: .orange)
            }
            
            Text("Your profile can be changed on the website.")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer()
        }.navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(settings: Settings(), image: Data())
    }
}
