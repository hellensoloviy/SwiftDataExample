//
//  ExpensesListView.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI
import SwiftData

#Preview {
    ExpensesListView(viewModel: .init())
}

struct ExpensesListView: View {
    
    @Environment(\.modelContext) private var modelContext

    @State private var isShowingItemSheet: Bool = false
    @State private var expenseToEdit: Expense?
    
    @StateObject var viewModel: ViewModel
    
    /// fetch using Query automatically
    @Query(sort: \Expense.date) var expenses: [Expense]
    
    /// Example of Predicate to filter the expense, not just sort.
    @Query(filter: #Predicate<Expense> { $0.value > 1000 } , sort: \Expense.date)
    var filteredExpenses: [Expense]
    
    private let addExpenseTip = AddExpenseTip()

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
            .contextMenu {
                if !expenses.isEmpty {
                    Button("Sort expenses", systemImage: "list.bullet.circle") {
                        //TODO: - filter action
                    }
                } else {
                    /// no action needded
                }
            }
            .sheet(isPresented: $isShowingItemSheet) {
                addExpenseTip.invalidate(reason: .actionPerformed)
                AddExpenseSheet()
            }
            .sheet(item: $expenseToEdit, content: { obj in
                /// this action happens when *$expenseToEdit* changed, and it changes when we tap on the cell
                UpdateExpenseSheet(expense: obj)
            })
            .toolbar {
                if !expenses.isEmpty {
                    
                    /// Be aware that **Button("name", systemImage:"")** will not show any popoverTip. So its changed to another initializer.
                    /// Its known issue in TipKit
                    /// But with this initializer we have less from the box and need to add *accessibilityLabel* ourselves
                    Button {
                        isShowingItemSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new expense")
                    .popoverTip(addExpenseTip)
                    
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

