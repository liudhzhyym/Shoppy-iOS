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
    @State var network: NetworkObserver
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
            ScrollView {
                Spacer()
                
                ForEach(network.queries, id: \.id) { (query: Query) in
                    NavigationLink(destination: QueryDetailView(network: self.network, query: query)) {
                        Group {
                            QueryCard(email: query.email ?? "",
                                      message: query.subject ?? "",
                                      date: query.updated_at ?? Date(),
                                      status: QueryStatus(rawValue: query.status ?? 0) ?? .Open)
                            
                            Divider()
                        }
                    }.buttonStyle(PlainButtonStyle())
                }
                
                Text("\(network.queries.count) \("queries".localized)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                if network.queries.count >= (25 * self.page) {
                    Button(action: loadMore) {
                        Text("Try to load more")
                    }.padding()
                }
                
                Spacer()
            }
            .id(UUID().uuidString)
            .navigationBarTitle("Queries", displayMode: .inline)
            .navigationBarItems(trailing: refreshButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QueriesView_Previews: PreviewProvider {
    static var previews: some View {
        QueriesView(network: NetworkObserver(key: ""))
    }
}
