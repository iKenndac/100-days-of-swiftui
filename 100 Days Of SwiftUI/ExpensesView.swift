//
//  ExpensesView.swift
//  100Days
//
//  Created by Daniel Kennett on 2019-11-13.
//  Copyright © 2019 Daniel Kennett. All rights reserved.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    let id: UUID = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expense: ObservableObject {
    @Published var items: [ExpenseItem] = []
}

// Stopped at: https://www.hackingwithswift.com/books/ios-swiftui/sharing-an-observed-object-with-a-new-view

struct ExpensesView: View {

    @ObservedObject var expenses: Expense = Expense()

    func removeItems(at indexSet: IndexSet) {
        expenses.items.remove(atOffsets: indexSet)
    }

    var body: some View {
        List {
            ForEach(expenses.items) { item in
                Text(item.name)
            }.onDelete(perform: removeItems)
        }
        .navigationBarTitle("iExpense")
        .navigationBarItems(trailing: Button(action: {
            let test = ExpenseItem(name: "Test", type: "Personal", amount: 5)
            self.expenses.items.append(test)
        }) {
            Image(systemName: "plus")
        })
    }

}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpensesView()
        }
    }
}

