//
//  ContainerNavigationButton.swift
//  Shoppy
//
//  Created by Victor Lourme on 07/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//
import SwiftUI

struct ContainerNavigationButton: View {
    @State public var title: String
    @State public var icon: String
    @State public var destination: AnyView
    @State public var accent: Color = Color.orange
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(accent)
                    .frame(maxWidth: 25)
                    .padding([.horizontal], 2)
                
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

struct ContainerNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        Container {
            ContainerNavigationButton(title: "Change API key", icon: "lock.fill", destination: AnyView(Text("")))
        }
    }
}
