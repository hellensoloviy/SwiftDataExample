//
//  ContentView.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI
import SwiftData

#Preview {
    ContentView()
}

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext

    @State private var isShowingItemSheet: Bool = false
    @State private var expenseToEdit: Expense?
    
    /// fetch using Query automatically
    @Query(sort: \Expense.date) var expenses: [Expense]
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(expenses) { obj in
                    ExpenseCell(expense: obj)
                        .onTapGesture {
                            expenseToEdit = obj
                        }
                }
                
                /// swipe to delete action
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(expenses[index])
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddExpenseSheet()
            }
            .sheet(item: $expenseToEdit, content: { obj in
                /// this action happens when *$expenseToEdit* changed, and it changes when we tap on the cell
                UpdateExpenseSheet(expense: obj)
            })
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView {
                        Label("No expenses", systemImage: "list.bullet.rectangle.portrait")
                    } description: {
                        Text("Start adding expenses to your list")
                    } actions: {
                        Button("Add expense") {
                            isShowingItemSheet = true
                        }
                    }
                    .offset(y: -60)
                }
            }
        }
    }
}

