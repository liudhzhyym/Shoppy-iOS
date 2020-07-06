//
//  ProductDetailView.swift
//  Shoppy
//
//  Created by Victor Lourme on 02/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy
import FancyScrollView

struct ProductDetailView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    @State public var product: Product
    
    var body: some View {
        Group {
            if product.image != nil {
                FancyScrollView(headerHeight: 350,
                                scrollUpHeaderBehavior: .parallax,
                                scrollDownHeaderBehavior: .sticky,
                                header: {
                                    Image(uiImage: ((imageLoader.image != nil) ?
                                        UIImage(data: imageLoader.image!): UIImage(systemName: "xmark"))!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                }) {
                    ProductSectionView(product: product)
                }
            } else {
                ScrollView {
                    ProductSectionView(product: product)
                }
            }
        }
        .onAppear() {
            if let url = self.product.image?.url {
                self.imageLoader.setImage(imageURL: url)
            }
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product())
    }
}
