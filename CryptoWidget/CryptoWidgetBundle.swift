//
//  CryptoWidgetBundle.swift
//  CryptoWidget
//
//  Created by Kim on 14.04.2025.
//

import WidgetKit
import SwiftUI

@main
struct CryptoWidgetBundle: WidgetBundle {
    var body: some Widget {
        CryptoWidget()
        CryptoWidgetLiveActivity()
    }
}
