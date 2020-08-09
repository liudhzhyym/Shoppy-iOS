//
//  Localization.swift
//  Shoppy
//
//  Created by Victor Lourme on 11/07/2020.
//  Copyright © 2020 Victor Lourme. All rights reserved.
//

import Foundation

extension String {
    ///
    /// Get localized string
    ///
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
