//
//  Container.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct Container<Content>: View where Content: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
        .padding([.leading, .trailing])
    }
}

struct Container_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            ContainerButton(title: "Hello world", icon: "gear", function: {})
            ContainerButton(title: "Hello world", icon: "gear", function: {})
        }
    }
}
