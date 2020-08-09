//
//  SafariView.swift
//  Shoppy
//
//  Created by Victor Lourme on 27/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    typealias UIViewControllerType = SFSafariViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}
