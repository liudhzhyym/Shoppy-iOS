//
//  Field.swift
//  Shoppy
//
//  Created by Victor Lourme on 01/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct Field: View {
    @State public var key: String
    @State public var value: String
    
    var body: some View {
        HStack {
            Text(key)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .lineLimit(0)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = self.value
                    }) {
                        Image(systemName: "doc.on.doc")
                        Text("Copy".localized)
                    }
                }
        }
    }
}

struct Field_Previews: PreviewProvider {
    static var previews: some View {
        Field(key: "ID", value: UUID().uuidString)
    }
}
