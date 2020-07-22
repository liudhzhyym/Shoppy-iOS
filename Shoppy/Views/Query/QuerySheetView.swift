//
//  QuerySheetView.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SwiftUI
import class SwiftyShoppy.NetworkManager
import struct SwiftyShoppy.Query
import struct SwiftyShoppy.ResourceUpdate
import struct SwiftyShoppy.QueryActionResponse
import enum SwiftyShoppy.QueryStatus

struct QuerySheetView: View {
    @State public var network: NetworkObserver
    @Binding public var query: Query
    @State public var token: String
    
    private func getDate(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm MMM dd"
        
        return df.string(from: date)
    }
    
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
                        
                        // Update queries
                        self.network.getQueries(page: 1)
                    }, error: { error in
                        print(error)
                    })
                }
            }, error: { error in
                print(error)
            })
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                
                Container {
                    ContainerField(name: "Status".localized, value: self.getState().localized, icon: "envelope")
                    ContainerField(name: "Sender".localized, value: self.query.email ?? "", icon: "person")
                    ContainerField(name: "Created on".localized, value: self.getDate(date: self.query.created_at ?? Date()), icon: "calendar")
                    ContainerField(name: "Query ID".localized, value: self.query.id ?? "", icon: "number")
                }.padding(.top)
                
                Button(action: changeState) {
                    if query.status == QueryStatus.Closed.rawValue {
                        Image(systemName: "lock.open")
                            .padding(.horizontal, 5)
                        
                        Text("Re-open this query")
                    } else {
                        Image(systemName: "lock")
                            .padding(.horizontal, 5)
                        
                        Text("Close this query")
                    }
                }
                .padding()
                .font(.headline)
                .foregroundColor(Color(query.status == QueryStatus.Closed.rawValue ? "PastelGreenSecondary" : "PastelRedSecondary"))
                .background(Color(query.status == QueryStatus.Closed.rawValue ? "PastelGreen" : "PastelRed"))
                .cornerRadius(20)
                
                if query.status != QueryStatus.Closed.rawValue {
                    Text("You can still re-open it later.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            .navigationBarTitle("Query detail", displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct QuerySheetView_Previews: PreviewProvider {
    static var previews: some View {
        QuerySheetView(network: NetworkObserver(key: ""), query: .constant(Query()), token: "")
    }
}
