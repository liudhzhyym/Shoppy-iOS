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

                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
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

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(isPresented: .constant(true))
    }
}
