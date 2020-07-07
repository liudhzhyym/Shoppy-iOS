//
//  LoginView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import KeychainSwift

struct LoginView: View {    
    // Keychain
    private let keychain = KeychainSwift()
    
    // Key
    @State private var key = ""
    
    // Error management
    @State private var isError = false
    
    // Is edit
    @State public var isEdit: Bool = false
    
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
                Image(systemName: "bag.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding()
                
                Text("WELCOME ON")
                    .font(.subheadline)
                
                Text("Shoppy")
                    .font(.largeTitle)
                    .bold()
            } else {
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding()
                
                Text("Change your API key")
                    .font(.title)
                    .bold()
            }
            
            TextField("API Key", text: $key)
                .padding()
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            Button(action: login) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text(isEdit ? "Save" : "Continue")
                }
            }.padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(15)
            
            Spacer()
            
            Text("Your API key is stored encrypted and never shared.")
                .font(.footnote)
                .foregroundColor(.secondary)
            
        }
        .padding()
        .alert(isPresented: $isError) {
            Alert(
                title: Text("Error"),
                message: Text("Wrong API key"),
                dismissButton: .cancel())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isEdit: false)
    }
}
