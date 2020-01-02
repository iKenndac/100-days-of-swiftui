//
//  RootNavigation.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-17.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct RootNavigation: View {

    var destinations: [(title: String, view: AnyView)] = [
        ("WeSplit", AnyView(WeSplitView())),
        ("Unit Converter", AnyView(UnitConverterView())),
        ("Guess The Flag", AnyView(GuessTheFlagView())),
        ("Views and Modifiers", AnyView(ViewsAndModifiersView())),
        ("Rock, Paper, Scissors", AnyView(RockPaperScissorsView())),
        ("BetterRest", AnyView(BetterRestView())),
        ("Word Scramble", AnyView(WordScrambleView())),
        ("Animation Test", AnyView(AnimationsView())),
        ("Animating Gestures & Transitions", AnyView(AnimatingGesturesAndTransitionsView())),
        ("iExpense", AnyView(ExpensesView()))
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(0..<destinations.count) { index in
                    NavigationLink(destination: self.destinations[index].view) { Text(self.destinations[index].title) }
                }
            }.navigationBarTitle("Projects").listStyle(GroupedListStyle())
        }
    }
}


struct RootNavigation_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigation()
    }
}

