//
//  ContainerField.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct ContainerField: View {
    @State public var name: String
    @State public var value: String
    @State public var icon: String
    @State public var accent: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(accent)
                .frame(maxWidth: 40)
            
            Text(name)
            
            Spacer()
            
            Text(value)
                .bold()
        }
        .padding(.vertical, 10)
    }
}

struct ContainerField_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            ContainerField(name: "App version", value: "1.2", icon: "info.circle", accent: .blue)
        }
    }
}
