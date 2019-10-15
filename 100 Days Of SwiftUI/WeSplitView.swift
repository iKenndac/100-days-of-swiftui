//
//  ContentView.swift
//  WeSplit
//
//  Created by Daniel Kennett on 2019-10-11.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct WeSplitView: View {
    @State private var checkAmount: String = ""
    @State private var numberOfPeopleIndex = 2
    @State private var tipPercentageIndex = 2

    let tipPercentages = [0.10, 0.15, 0.20, 0.25, 0.0]
    let numberOfPeopleRange = 2..<99

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeopleIndex + numberOfPeopleRange.lowerBound)
        let tipSelection = Double(tipPercentages[tipPercentageIndex])
        let orderAmount = Double(checkAmount) ?? 0.0

        return (orderAmount + (orderAmount * tipSelection)) / peopleCount
    }

    var overallTotal: Double {
        let tipSelection = Double(tipPercentages[tipPercentageIndex])
        let orderAmount = Double(checkAmount) ?? 0.0
        return orderAmount + (orderAmount * tipSelection)
    }

    var body: some View {
        NavigationView {
        Form {
            Section {
                TextField("Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
                Picker("Number of people", selection: $numberOfPeopleIndex) {
                    ForEach(numberOfPeopleRange) { number in
                        Text("\(number) people")
                    }
                }
            }
            Section(header: Text("Tip Percentage".uppercased())) {
                Picker("Tip percentage", selection: $tipPercentageIndex) {
                    ForEach(0 ..< tipPercentages.count) {
                        Text("\(Int(self.tipPercentages[$0] * 100.0))%")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Total Per Person".uppercased())) {
                Text("$\(totalPerPerson, specifier: "%.2f")")
            }
            Section(header: Text("Overall Total".uppercased())) {
                Text("$\(overallTotal, specifier: "%.2f")")
            }
        }
        .navigationBarTitle("WeSplit")
        }
    }
}
struct WeSplitView_Previews: PreviewProvider {
    static var previews: some View {
        WeSplitView()
    }
}
