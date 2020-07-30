//
//  LoginView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Analytics
import class SwiftyShoppy.NetworkManager
import KeychainSwift
import KeyboardObserving

struct LoginView: View {
    // Keychain
    private let keychain = KeychainSwift()
    
    // Key
    @State private var key = ""
    
    // Error management
    @State private var isError = false
    
    // Is edit
    @State public var isEdit: Bool = false
    
    // EnvironmentObject workaround for sheet modals
    @State public var network: NetworkObserver
    
    // SafariVC
    @State private var showSafari = false
    
    ///
    /// Login method
    ///
    private func login() {
        // Try to get analytics
        NetworkManager
            .prepare(token: key)
            .target(.getAnalytics)
            .asObject(Analytics.self, success: { analytics in
                print("[LoginView] Key is valid")
                
                // Store key
                self.keychain.set(self.key, forKey: "key")
                
                // Reload with key
                self.network.updateKey(key: self.key)
                self.network.loadAll()
                
                // Close modal
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }, error: { error in
                print(error)
                self.isError = true
                print("[LoginView] Invalid key")
                return
            })
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if !isEdit {
                Image(systemName: "cart.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Welcome on Shoppy")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
                
                Text("Manage your commerce like never before, welcome on a easy way to manage your orders, products, customers' queries and more.")
                    .padding()
                    .font(.system(.body, design: .rounded))
                    .multilineTextAlignment(.center)
            } else {
                Image(systemName: "lock.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Change your API key")
                    .font(.title)
                    .bold()
            }
            
            TextField("API key", text: $key)
                .padding()
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.top)
            
            Button(action: login) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text(isEdit ? "Save" : "Continue")
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(15)
            
            Button(action: {
                self.showSafari.toggle()
            }) {
                Text("You can find your API key in Settings on your Shoppy account. ")
                    + Text("Get my API key.")
                        .foregroundColor(.orange)
                        .bold()
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
            
            
            Spacer()
            
            Text("Your API key is stored encrypted and never shared.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .keyboardObserving()
        .alert(isPresented: $isError) {
            Alert(title: Text("Error"),
                  message: Text("Wrong API key"),
                  dismissButton: .cancel())
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: "https://shoppy.gg/auth/login")!)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(isEdit: false, network: NetworkObserver(key: ""))
            
            LoginView(isEdit: true, network: NetworkObserver(key: ""))
        }
    }
}
