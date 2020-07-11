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
            Group {
                Container {
                    ContainerField(name: "Status".localized, value: self.order.delivered == 1 ? "Paid".localized : "Unpaid".localized, icon: "flag.fill")
                    ContainerField(name: "Created at".localized, value: self.order.created_at?.description ?? "", icon: "clock.fill")
                    
                    if self.order.delivered == 1 {
                        ContainerField(name: "Paid using".localized, value: self.order.gateway ?? "", icon: "creditcard.fill")
                        ContainerField(name: "Paid at".localized, value: self.order.paid_at?.description ?? "", icon: "calendar")
                    }
                }
                
                Container {
                    ContainerField(name: "Price".localized, value: "\(self.order.price ?? 0)", icon: "bag.fill")
                    ContainerField(name: "Quantity".localized, value: "\(self.order.quantity ?? 0)", icon: "cart.fill")
                    ContainerField(name: "Total price".localized, value: "\((self.order.price ?? 0) * Double(self.order.quantity ?? 0))", icon: "equal.square.fill")
                    ContainerField(name: "Currency".localized, value: self.order.currency ?? "", icon: "dollarsign.circle.fill")
                }
                
                Container {
                    ContainerField(name: "Email".localized, value: self.order.email ?? "", icon: "person.fill")
                    ContainerField(name: "IP".localized, value: self.order.agent?.geo?.ip ?? "", icon: "globe")
                    ContainerField(name: "Country".localized, value: self.order.agent?.geo?.country ?? "", icon: "mappin")
                    ContainerField(name: "Platform".localized, value: self.order.agent?.data?.platform ?? "", icon: "aspectratio")
                }
                
                Container {
                    if self.order.product != nil {
                        // Note: is there a way to bypass AnyView?
                        ContainerNavigationButton(title: "See the product".localized, icon: "cube.box.fill", destination: AnyView(ProductDetailView(product: self.order.product!)))
                    }
                    
                    if self.order.delivered == 1 && self.order.product?.type == .account {
                        ContainerNavigationButton(title: "See delivered accounts".localized, icon: "line.horizontal.3.decrease", destination: AnyView(OrderAccountView(order: self.order)))
                    }
                }
                
                Container {
                    ContainerField(name: "Order ID".localized, value: self.order.id ?? "", icon: "number")
                    ContainerField(name: "Product ID".localized, value: self.order.product_id ?? "", icon: "cube.box")
                    
                    if self.order.is_replacement ?? false {
                        ContainerField(name: "Replacement ID".localized, value: self.order.replacement_id ?? "", icon: "arrow.right.arrow.left")
                    }
                    
                    if self.order.coupon_id != nil {
                        ContainerField(name: "Coupon ID".localized, value: self.order.coupon_id ?? "", icon: "tag.fill")
                    }
                    
                    ContainerField(name: "Hash".localized, value: self.order.hash ?? "", icon: "signature")
                }
            }.padding([.top, .bottom])
            
            .navigationBarTitle("Order", displayMode: .inline)
        }
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
