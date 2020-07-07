//
//  ProductDescriptionView.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct ProductDetailledView: View {
    @State public var name: String
    @State public var value: String
    
    var body: some View {
        ScrollView {
            Text(value)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }.navigationBarTitle(name)
    }
}

struct ProductDetailledView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailledView(name: "Name", value: "Lorem Ipsum")
    }
}
