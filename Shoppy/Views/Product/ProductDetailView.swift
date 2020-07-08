//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 02/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import KeychainSwift

struct ProductDetailView: View {
    @State public var product: Product
    @State private var isUnlisted: Bool = false
    
    var body: some View {
        ScrollView {
            Container {
                ContainerNavigationButton(title: "See the description", icon: "text.alignleft", destination: AnyView(ProductDetailledView(name: "Description", value: self.product.description!)))
                ContainerField(name: "Delivery type", value: self.product.type?.rawValue.capitalized ?? "", icon: "cube.box")
            }
            
            Container {
                ContainerField(name: "Price", value: "\(self.product.price ?? 0)", icon: "bag.fill")
                ContainerField(name: "Revenue per order", value: "\((self.product.price ?? 0) * Double(self.product.quantity?.min ?? 0))", icon: "equal.square")
                ContainerField(name: "Potential total", value: "\((self.product.price ?? 0) * Double(self.product.stock?.get() ?? 0))", icon: "equal.square.fill")
                ContainerField(name: "Currency", value: self.product.currency ?? "", icon: "dollarsign.circle.fill")
            }
            
            Container {
                ContainerField(name: "Stock", value: "\(self.product.stock?.get() ?? 0)", icon: "cart.fill")
                ContainerField(name: "Minimum quantity per order", value: "\(self.product.quantity?.min ?? 0)", icon: "minus.circle.fill")
                ContainerField(name: "Maximum quantity per order", value: "\(self.product.quantity?.max ?? 0)", icon: "plus.circle.fill")
            }
            
            Container {
                ContainerField(name: "Unlisted", value: self.product.unlisted ?? false ? "Yes" : "No", icon: "eye.slash")
                ContainerField(name: "Product ID", value: self.product.id ?? "", icon: "number")
                ContainerField(name: "Creation date", value: self.product.created_at?.description ?? "", icon: "calendar")
                ContainerField(name: "Last update", value: self.product.updated_at?.description ?? "", icon: "clock.fill")
            }
            
            Spacer()
        }
        .navigationBarTitle(product.title ?? "Product")
        .onAppear {
            self.isUnlisted = self.product.unlisted ?? false
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product())
    }
}
