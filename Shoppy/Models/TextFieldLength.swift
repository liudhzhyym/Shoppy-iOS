//
//  TextFieldLength.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import Foundation
import Combine

class TextFieldLength: ObservableObject {
    let subscriber = PassthroughSubject<Void, Never>()
    
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
            
            subscriber.send()
        }
    }
    
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}
