//
//  Label.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct Label: View {
    @State public var label: String
    @State public var value: String?
    @State public var showChevron: Bool = false
    @State public var icon: String
    @State public var color = Color.blue
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .padding()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(5)
            
            Text(label)
            
            Spacer()
            
            Text(value ?? "")
                .foregroundColor(.secondary)
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .font(.headline)
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
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

struct Label_Previews: PreviewProvider {
    static var previews: some View {
        Label(label: "Name", value: "Value", icon: "gear")
    }
}
