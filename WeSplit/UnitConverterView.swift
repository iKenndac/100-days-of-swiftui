//
//  UnitConverterView.swift
//  WeSplit
//
//  Created by Daniel Kennett on 2019-10-11.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct TemperatureUnit: Hashable {

    static func == (lhs: TemperatureUnit, rhs: TemperatureUnit) -> Bool {
        return lhs.symbol == rhs.symbol
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }

    static let celcius = TemperatureUnit(symbol: "°C", toKelvin: { $0 + 273.15 }, fromKelvin: { $0 - 273.15 })
    static let kelvin = TemperatureUnit(symbol: "K", toKelvin: { $0 }, fromKelvin: { $0 })
    static let fahrenheit = TemperatureUnit(symbol: "°F", toKelvin: { ($0 - 32.0) / 1.8 + 273.15 },
                                            fromKelvin: { ($0 * 1.8) - 459.67 })



    let symbol: String
    let toKelvin: (Double) -> Double
    let fromKelvin: (Double) -> Double
}

struct UnitConverterView: View {

    let units: [TemperatureUnit] = [.celcius, .fahrenheit, .kelvin]
    @State var fromUnit: TemperatureUnit = .celcius
    @State var toUnit: TemperatureUnit = .fahrenheit
    @State var input: String = ""

    var output: Double {
        let inputTemperature = Double(input) ?? 0.0
        return toUnit.fromKelvin(fromUnit.toKelvin(inputTemperature))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("From".uppercased())) {
                    TextField("Temperature", text: $input).keyboardType(.decimalPad)
                    HStack {
                        Text("From")
                        Picker("Unit", selection: $fromUnit) {
                            ForEach(units, id: \.self) {
                                Text("\($0.symbol)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        Text("To     ")
                        Picker("Unit", selection: $toUnit) {
                            ForEach(units, id: \.self) {
                                Text("\($0.symbol)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                Section(header: Text("Result".uppercased())) {
                    Text("\(output, specifier: "%.1f") \(toUnit.symbol)").frame(alignment: .center)
                }
            }
            .navigationBarTitle("Unit Converter")
        }
    }
}

struct UnitConverterView_Previews: PreviewProvider {
    static var previews: some View {
        UnitConverterView()
    }
}


