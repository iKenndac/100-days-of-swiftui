//
//  ExpensesView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-11-13.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id: UUID = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expense: ObservableObject {

    init() {
        guard let data = UserDefaults.standard.data(forKey: "Items"),
            let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: data) else {
                items = []
                return
        }
        items = decoded
    }

    @Published var items: [ExpenseItem] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ExpensesView: View {

    @ObservedObject var expenses: Expense = Expense()
    @State private var showingAddExpense: Bool = false

    func removeItems(at indexSet: IndexSet) {
        expenses.items.remove(atOffsets: indexSet)
    }

    var body: some View {
        List {
            ForEach(expenses.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.type)
                    }

                    Spacer()
                    Text("$\(item.amount)")
                }
            }.onDelete(perform: removeItems)
        }
        .navigationBarTitle("iExpense")
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
            self.showingAddExpense = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddExpense, content: { AddView(expenses: self.expenses) })
    }

}

struct AddView: View {
    @State private var name: String = ""
    @State private var type: String = "Personal"
    @State private var amount: String = ""

    @State private var errorTitle = "Invalid Input"
    @State private var errorMessage = ""
    @State private var showingError = false

    @ObservedObject var expenses: Expense
    @Environment(\.presentationMode) var presentationMode

    static let types: [String] = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount).keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(leading: Button("Cancel") { self.presentationMode.wrappedValue.dismiss() }, trailing: Button("Save") {
                guard let actualAmount = Int(self.amount) else {
                    self.errorMessage = "Please make sure you're entering a valid amount."
                    self.showingError = true
                    return
                }

                guard self.name.count > 0 else {
                    self.errorMessage = "Please make sure you're entering a valid name."
                    self.showingError = true
                    return
                }

                let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                self.expenses.items.append(item)
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingError, content: {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            })
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpensesView()
        }
    }
}

