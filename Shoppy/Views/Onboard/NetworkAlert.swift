//
//  NetworkAlert.swift
//  Shoppy
//
//  Created by Victor Lourme on 09/08/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct NetworkAlert: View {
    @Binding public var isPresented: Bool
    @State public var network: NetworkObserver
    @State private var attemps: Int = 0

    var body: some View {
        HStack {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 26))
                .padding([.leading, .trailing], 10)

            VStack(alignment: .leading) {
                Text("Network issue")
                    .bold()

                Text("You don't have network connection. Tap this card to retry.")
                    .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .padding()
        .modifier(Shake(animatableData: CGFloat(attemps)))
        .opacity(isPresented ? 1 : 0)
        .animation(.easeOut)
        .transition(.slide)
        .onTapGesture {
            // Check for network
            if !Reachability.isConnectedToNetwork() {
                self.attemps += 1
                return
            }

            // Reload all
            self.network.loadAll()

            // Dismiss card
            self.isPresented = false
        }
    }
}

struct NetworkModifier: ViewModifier {
    @Binding public var isPresented: Bool
    @State public var network: NetworkObserver

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            NetworkAlert(isPresented: $isPresented, network: network)
        }
    }
}

extension View {
    ///
    /// Show alert due to network issue
    /// - parameters:
    ///     - isPresented: Binding to display or not the alert
    ///     - network: NetworkObserver
    ///
    func networkAlert(isPresented: Binding<Bool>, network: NetworkObserver) -> some View {
        self.modifier(NetworkModifier(isPresented: isPresented, network: network))
    }
}
