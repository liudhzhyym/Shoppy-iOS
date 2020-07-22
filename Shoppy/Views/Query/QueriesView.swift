//
//  QueriesView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import struct SwiftyShoppy.Query
import enum SwiftyShoppy.QueryStatus

struct QueriesView: View {
    @EnvironmentObject var network: NetworkObserver
    @State private var page: Int = 1
    
    private func loadMore() {
        // Increment page
        self.page += 1
        
        // Load more
        self.network.getQueries(page: self.page)
    }
    
    var refreshButton: some View {
        Button(action: {
            self.network.getQueries(page: 1)
        }) {
            Image(systemName: "arrow.2.circlepath.circle.fill")
                .resizable()
                .frame(width: 26, height: 26)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("\(network.queries.count) \("queries".localized)".uppercased()),
                    footer: Button(action: loadMore) {
                        if network.queries.count >= (25 * self.page) {
                            Text("Try to load more")
                        }
                    }) {
                    ForEach(network.queries, id: \.id) { (query: Query) in
                        NavigationLink(destination: QueryDetailView(query: query)) {
                            QueryCard(email: query.email ?? "",
                                      message: query.subject ?? "",
                                      date: query.updated_at ?? Date(),
                                      status: QueryStatus(rawValue: query.status ?? 0) ?? .Open)
                        }
                        .listRowInsets(EdgeInsets())
                        .padding(.trailing)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Support center")
            .navigationBarItems(trailing: refreshButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QueriesView_Previews: PreviewProvider {
    static var previews: some View {
        QueriesView()
    }
}
