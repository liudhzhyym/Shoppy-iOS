//
//  OnboardView.swift
//  Shoppy
//
//  Created by Victor Lourme on 09/08/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI

struct OnboardView: View {
    @Binding public var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    VStack {
                        VStack(alignment: .leading) {
                            Image("Icon")
                                .resizable()
                                .frame(width: 92, height: 92)
                                .cornerRadius(25)
                            
                            Text("Welcome on Shoppy")
                                .font(.title)
                            
                            Text("Manage your products, invoices and reply to your customers needs.")
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                ActivityIndicator()
                    .padding(.top, 50)
            }
        }
        .opacity(isPresented ? 1 : 0)
        .animation(.easeInOut)
        .transition(.opacity)
    }
}

struct OnboardMod: ViewModifier {
    @Binding public var isPresented: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            OnboardView(isPresented: $isPresented)
        }
    }
}

extension View {
    func onboard(isPresented: Binding<Bool>) -> some View {
        self.modifier(OnboardMod(isPresented: isPresented))
    }
}

struct ActivityIndicator: View {
    @State private var animating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .foregroundColor(.primary)
            .frame(width: 50, height: 50)
            .rotationEffect(Angle(degrees: animating ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear {
                self.animating = true
            }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(isPresented: .constant(true))
    }
}
