//
//  QueriesView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

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
        ScrollView {
            ForEach(network.queries, id: \.id) { (query: Query) in
                QueryCard(query: query)
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
        .navigationBarTitle("Queries")
        .navigationBarItems(trailing: refreshButton)
    }
}

struct QueriesView_Previews: PreviewProvider {
    static var previews: some View {
        QueriesView()
    }
}
