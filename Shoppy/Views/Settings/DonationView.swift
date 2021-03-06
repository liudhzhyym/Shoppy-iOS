//
//  DonationView.swift
//  Shoppy
//
//  Created by Victor Lourme on 31/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

enum DonationStatus {
    case success, fail
}

struct DonationView: View {
    // Alerts
    @State private var alert = false
    @State private var status: DonationStatus = .fail

    ///
    /// Donation method
    ///
    func makeDonation(product: String) {
        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
            switch result {
                case .success:
                    self.status = .success
                case .error:
                    self.status = .fail
            }

            self.alert.toggle()
        }
    }

    ///
    /// Body
    ///
    var body: some View {
        Form {
            Text("This application is developed and distributed for free. Please consider doing a small donation to help the future of the app.")

            Section {
                Button(action: {
                    self.makeDonation(product: "SM_TIP")
                }) {
                    Label(label: "Donate $1", showChevron: true, icon: "1.circle.fill", color: .green)
                }

                Button(action: {
                    self.makeDonation(product: "MD_TIP")
                }) {
                    Label(label: "Donate $3", showChevron: true, icon: "3.circle.fill", color: .green)
                }
            }.buttonStyle(PlainButtonStyle())

            Text("You can also contribute to the app on GitHub by reporting issues and proposing new features.")
        }
        .navigationBarTitle("Make a donation")
        .alert(isPresented: $alert) {
            if self.status == .success {
                return Alert(title: Text("Thank you!"),
                             message: Text("Thank you for donation, it's so lovely!"),
                             dismissButton: .default(Text("Close")))
            } else {
                return Alert(title: Text("Error"),
                             message: Text("It seems there was an error."),
                             dismissButton: .cancel())
            }
        }
    }
}

struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DonationView()
        }
    }
}
