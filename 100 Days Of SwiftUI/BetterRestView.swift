//
//  BetterRestView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-10-19.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct BetterRestView: View {

    @State private var wakeUp: Date = BetterRestView.defaultWakeTime
    @State private var sleepAmount: Double = 8.0
    @State private var coffeeAmount: Int = 1

    static var defaultWakeTime: Date = {
        let components = DateComponents(hour: 7, minute: 0)
        return Calendar.current.date(from: components) ?? Date()
    }()

    var calculatedBedtime: String {
        let model = SleepCalculator()

        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hoursInSeconds: TimeInterval = (TimeInterval(components.hour ?? 0)) * 60.0 * 60.0
        let minutesInSeconds: TimeInterval = (TimeInterval(components.minute ?? 0)) * 60.0
        let wakeupTime = hoursInSeconds + minutesInSeconds

        do  {
            let prediction = try model.prediction(wake: wakeupTime, estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sleepTime)
        } catch {
            print("Error calculating bedtime: \(error.localizedDescription)")
            return "???"
        }
    }

    var body: some View {
        Form {
            Section(header: Text("When do you want to wake up?".uppercased())) {
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
            }
            Section(header: Text("Desired amount of sleep".uppercased())) {
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
            }
            Section(header: Text("Daily coffee intake".uppercased())) {
                Picker("Number of cups", selection: $coffeeAmount) {
                    ForEach(0...20, id: \.self) { cups in
                        Text("\(cups) \(cups == 1 ? "cup" : "cups")")
                    }
                }.labelsHidden().pickerStyle(WheelPickerStyle())
            }
            Section(header: Text("Your recommended bedtime".uppercased())) {
                Text(calculatedBedtime).font(.title).frame(maxWidth: .infinity, minHeight: 60.0, alignment: .center)
            }
        }
        .navigationBarTitle("BetterRest")
    }
}

struct BetterRestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BetterRestView()
        }
    }
}
