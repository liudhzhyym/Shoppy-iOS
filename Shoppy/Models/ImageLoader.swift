//
//  ImageLoader.swift
//  Shoppy
//
//  Created by Victor Lourme on 02/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published public var image: Data?
    
    public func setImage(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = data
            }
            
        }.resume()
    }
}
