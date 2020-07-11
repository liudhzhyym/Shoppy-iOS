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
    
    private func changeState() {
        guard let id = query.id else {
            return
        }
        
        NetworkManager
            .prepare(token: token)
            .target(.updateQuery(id, action: query.status == QueryStatus.Closed.rawValue ? .ReOpen : .Close))
            .asObject(ResourceUpdate<Query>.self, success: { update in
                if update.status == true {
                    if let query = update.resource {
                        self.query = query
                    }
                }
            }, error: { error in
                print(error)
            })
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Query detail")
                    .font(.title)
                    .bold()
                
                Spacer()
            }.padding()
            
            ScrollView {
                Container {
                    if self.query.status == QueryStatus.Open.rawValue {
                        ContainerField(name: "Status", value: "Open", icon: "envelope.badge")
                    } else if self.query.status == QueryStatus.Closed.rawValue {
                        ContainerField(name: "Status", value: "Closed", icon: "envelope.badge")
                    } else if self.query.status == QueryStatus.Replied.rawValue {
                        ContainerField(name: "Status", value: "Replied", icon: "envelope.badge")
                    } else if self.query.status == QueryStatus.UserReply.rawValue {
                        ContainerField(name: "Status", value: "User replied", icon: "envelope.badge")
                    }
                    
                    ContainerField(name: "Sender", value: self.query.email ?? "", icon: "person")
                    ContainerField(name: "Created on", value: self.query.created_at?.description ?? "", icon: "calendar")
                    ContainerField(name: "Query ID", value: self.query.id ?? "", icon: "number")
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
