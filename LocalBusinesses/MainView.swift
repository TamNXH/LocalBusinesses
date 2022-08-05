//
//  ContentView.swift
//  LocalBusinesses
//
//  Created by TamNXH on 03/08/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        BusinessListView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
