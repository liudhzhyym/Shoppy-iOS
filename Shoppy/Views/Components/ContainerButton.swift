//
//  ContainerButton.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct ContainerButton: View {
    @State public var title: String
    @State public var icon: String
    @State public var function: () -> ()
    @State public var accent: Color = Color.blue
    
    var body: some View {
        Button(action: function) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(accent)
                    .frame(maxWidth: 40)
                
                Text(title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 10)
    }
}

struct ContainerButton_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            ContainerButton(title: "Change API key", icon: "lock.fill", function: {})
            ContainerButton(title: "Reset API key", icon: "lock.open.fill", function: {})
        }
    }
}
