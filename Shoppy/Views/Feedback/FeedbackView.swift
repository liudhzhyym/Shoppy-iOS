//
//  FeedbackView.swift
//  Shoppy
//
//  Created by Victor Lourme on 29/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Feedback

struct FeedbackView: View {
    @State public var network: NetworkObserver
    @State private var page: Int = 1

    private func loadMore() {
        // Increment page
        self.page += 1

        // Load more
        self.network.getFeedbacks(page: self.page)
    }

    var refreshButton: some View {
        Button(action: {
            self.page = 1
            self.network.getFeedbacks(page: self.page)
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .resizable()
                .frame(width: 26, height: 26)
        }
    }

    var body: some View {
        List {
            Section(header: Text("\(self.network.feedbacks.count) \("feedbacks".localized)".uppercased())) {
                ForEach(self.network.feedbacks, id: \.id) { (feedback: Feedback) in
                    FeedbackCardView(feedback: feedback)
                        .onAppear {
                            if self.network.feedbacks.last == feedback {
                                if self.network.feedbacks.count >= (25 * self.page) {
                                    self.loadMore()
                                }
                            }
                    }
                }.listRowInsets(EdgeInsets())
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Feedbacks")
        .navigationBarItems(trailing: refreshButton)
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedbackView(network: NetworkObserver(key: ""))
        }
    }
}
