//
//  HeroView.swift
//  Shoppy
//
//  Created by Victor Lourme on 30/06/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct HeroView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Shoppy")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 26, height: 26)
            }
            .padding(.top, 50)
            
            Spacer()
            
            HStack {
                Spacer()
                
                VStack {
                    HStack {
                        Text("50")
                            .font(.title)
                            .bold()
                        + Text("$")
                            .font(.subheadline)
                    }
                    .padding()
                    
                    Text("Total Revenues")
                }
                
                Spacer()
                
                VStack {
                    Text("15")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    Text("Total orders")
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding()
        .frame(height: 400)
        .foregroundColor(.white)
        .background(Color.orange)
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.top)
    }
}

struct HeroView_Previews: PreviewProvider {
    static var previews: some View {
        HeroView()
    }
}
