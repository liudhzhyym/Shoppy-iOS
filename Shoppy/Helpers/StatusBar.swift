//
//  StatusBar.swift
//  Shoppy
//
//  Created by Victor Lourme on 21/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import Foundation
import SwiftUI

class ContentHostingController: UIHostingController<AnyView> {
    ///
    /// Actual status bar style
    ///
    private var currentStatusBarStyle: UIStatusBarStyle = .default
    
    ///
    /// Override preferred style
    ///
    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentStatusBarStyle
    }
    
    ///
    /// Set the style and notify
    ///
    func changeStatusBarStyle(_ style: UIStatusBarStyle) {
        self.currentStatusBarStyle = style
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

extension UIApplication {
    ///
    /// Change status bar style from the View
    ///
    class func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let vc = UIApplication.getKeyWindow()?.rootViewController as? ContentHostingController {
            vc.changeStatusBarStyle(style)
        }
    }
    
    ///
    /// Get top window
    ///
    private class func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first{ $0.isKeyWindow }
    }
}
