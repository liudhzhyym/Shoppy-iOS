//
//  OrderDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct OrderDetailView: View {
    @State public var order: Order
    
    var body: some View {
        ScrollView {
            Container {
                ContainerField(name: "Status", value: self.order.delivered == 1 ? "Paid" : "Unpaid", icon: "flag.fill")
                ContainerField(name: "Created at", value: self.order.created_at?.description ?? "", icon: "clock.fill")
                
                if self.order.delivered == 1 {
                    ContainerField(name: "Paid using", value: self.order.gateway ?? "", icon: "creditcard.fill")
                    ContainerField(name: "Paid at", value: self.order.paid_at?.description ?? "", icon: "calendar")
                }
            }
            
            Container {
                ContainerField(name: "Price", value: "\(self.order.price ?? 0)", icon: "bag.fill")
                ContainerField(name: "Quantity", value: "\(self.order.quantity ?? 0)", icon: "cart.fill")
                ContainerField(name: "Total price", value: "\((self.order.price ?? 0) * Double(self.order.quantity ?? 0))", icon: "equal.square.fill")
                ContainerField(name: "Currency", value: self.order.currency ?? "", icon: "dollarsign.circle.fill")
            }
            
            Container {
                ContainerField(name: "Email", value: self.order.email ?? "", icon: "person.fill")
                ContainerField(name: "IP", value: self.order.agent?.geo?.ip ?? "", icon: "globe")
                ContainerField(name: "Country", value: self.order.agent?.geo?.country ?? "", icon: "mappin")
                ContainerField(name: "Platform", value: self.order.agent?.data?.platform ?? "", icon: "aspectratio")
            }
            
            Container {
                if self.order.product != nil {
                    // Note: is there a way to bypass AnyView?
                    ContainerNavigationButton(title: "See the product", icon: "cube.box.fill", destination: AnyView(ProductDetailView(product: self.order.product!)))
                }
                
                if self.order.delivered == 1 && self.order.product?.type == .account {
                    ContainerNavigationButton(title: "See delivered accounts", icon: "line.horizontal.3.decrease", destination: AnyView(OrderAccountView(order: self.order)))
                }
            }
            
            Container {
                ContainerField(name: "Order ID", value: self.order.id ?? "", icon: "number")
                ContainerField(name: "Product ID", value: self.order.product_id ?? "", icon: "cube.box")
                
                if self.order.is_replacement ?? false {
                    ContainerField(name: "Replacement ID", value: self.order.replacement_id ?? "", icon: "arrow.right.arrow.left")
                }
                
                if self.order.coupon_id != nil {
                    ContainerField(name: "Coupon ID", value: self.order.coupon_id ?? "", icon: "tag.fill")
                }
                
                ContainerField(name: "Hash", value: self.order.hash ?? "", icon: "signature")
            }
            
            Spacer()
        }.navigationBarTitle("Order")
    }
}

///
/// Preview
///
struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailView(order: Order())
    }
}
