//
//  SettingsView.swift
//  Shoppy
//
//  Created by Victor Lourme on 03/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var displayLogin = false
    
    // Change key
    private func changeKey() {
        self.displayLogin = true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API")) {
                    Button(action: changeKey) {
                        Text("Change API key")
                    }
                }
            }
                
            .navigationBarTitle("Settings", displayMode: .inline)
        }.sheet(isPresented: $displayLogin) {
            LoginView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
