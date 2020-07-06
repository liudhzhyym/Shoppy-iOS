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
    @State public var image: ImageLoader
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(uiImage: ((image.image != nil) ?
                        UIImage(data: image.image!): UIImage(systemName: "person"))!)
                        .resizable()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading) {
                        Text(settings.user?.username ?? "Username")
                            .font(.title)
                            .bold()
                        
                        Text(settings.user?.email ?? "email@provider.tld")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }.padding()
                    
                    Spacer()
                }
            }
            
            Section(header: Text("Gateways"),
                    footer: Text("You can edit gateways from the website.")) {
                Field(key: "Bitcoin", value: settings.settings?.bitcoinAddress ?? "Not set")
                Field(key: "Litecoin", value: settings.settings?.litecoinAddress ?? "Not set")
                Field(key: "Ethereum", value: settings.settings?.ethereumAddress ?? "Not set")
                Field(key: "PayPal", value: settings.settings?.paypalAddress ?? "Not set")
                Field(key: "Stripe ID", value: settings.settings?.stripeAccountId ?? "Not linked")
            }
                
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(settings: Settings(), image: ImageLoader())
    }
}
