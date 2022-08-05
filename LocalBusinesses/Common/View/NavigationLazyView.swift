//
//  NavigationLazyView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import SwiftUI

// Lazy load view when init a view in NavigationLink

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
