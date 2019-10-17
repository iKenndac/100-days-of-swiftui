//
//  RootNavigation.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-17.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct RootNavigation: View {

    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: WeSplitView()) { Text("WeSplit") }
                NavigationLink(destination: UnitConverterView()) { Text("Unit Converter") }
                NavigationLink(destination: GuessTheFlagView()) { Text("Guess The Flag") }
                NavigationLink(destination: ViewsAndModifiersView()) { Text("Views and Modifiers") }
            }.navigationBarTitle("Projects")
        }
    }
}


struct RootNavigation_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigation()
    }
}

