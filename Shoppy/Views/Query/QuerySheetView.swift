//
//  QuerySheetView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import SwiftyShoppy

struct QuerySheetView: View {
    @Binding public var query: Query
    @State public var token: String
    
    public func getState() -> String {
        switch query.status {
        case QueryStatus.Closed.rawValue:
            return "Closed"
        case QueryStatus.Replied.rawValue:
            return "Replied"
        case QueryStatus.UserReply.rawValue:
            return "User replied"
        default:
            return "Open"
        }
    }
    
    private func changeState() {
        guard let id = query.id else {
            return
        }
        
        NetworkManager
            .prepare(token: token)
            .target(.updateQuery(id, action: query.status == QueryStatus.Closed.rawValue ? .ReOpen : .Close))
            .asObject(ResourceUpdate<QueryActionResponse>.self, success: { update in
                if update.status == true {
                    // Get query
                    NetworkManager
                        .prepare(token: self.token)
                    .target(.getQuery(id))
                    .asObject(Query.self, success: { query in
                        // Set query
                        self.query = query
                        
                        // Update status
                        //self.status = self.getState()
                    }, error: { error in
                        print(error)
                    })
                }
            }, error: { error in
                print(error)
            })
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                Text("Query detail")
                    .font(.title)
                    .bold()
                    
                Text(self.getState().localized)
                    .font(.callout)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }.padding()
            
            ScrollView {
                Container {
                    ContainerField(name: "Sender".localized, value: self.query.email ?? "", icon: "person")
                    ContainerField(name: "Created on".localized, value: self.query.created_at?.description ?? "", icon: "calendar")
                    ContainerField(name: "Query ID".localized, value: self.query.id ?? "", icon: "number")
                }
                
                Button(action: changeState) {
                    Text(query.status == QueryStatus.Closed.rawValue ? "Re-open this query" : "Close this query")
                }.padding()
            }
        }
    }
}

struct QuerySheetView_Previews: PreviewProvider {
    static var previews: some View {
        QuerySheetView(query: .constant(Query()), token: "")
    }
}
