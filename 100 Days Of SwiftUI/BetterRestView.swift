//
//  BetterRestView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-19.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct BetterRestView: View {

    @State private var sleepAmount: Double = 8.0
    @State private var wakeUp: Date = Date()

    var body: some View {
        List {
            Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                Text("\(sleepAmount, specifier: "%g") hours")
            }
        DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
        }
    }

}

struct BetterRestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BetterRestView()
        }
    }
}
