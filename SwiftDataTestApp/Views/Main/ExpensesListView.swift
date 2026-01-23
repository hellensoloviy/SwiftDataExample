//
//  ExpensesListView.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI
import SwiftData
import TipKit


@MainActor
enum PreviewContainers {
    static var expenses: ModelContainer {
        let container = try! ModelContainer(
            for: Expense.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )

        container.mainContext
            .insert(Expense(name: "Coffee", date: .now, value: 33.5))
        container.mainContext
            .insert(Expense(name: "Lunch",  date: .now.addingTimeInterval(-3600), value: 1200))
        container.mainContext
            .insert(Expense(name: "Groceries", date: .now.addingTimeInterval(-86400), value: 450.5))
        
        return container
    }
}

#Preview("Full list") {
    ExpensesListView(viewModel: .init())
        .modelContainer(PreviewContainers.expenses)
        .task {
            try? await Tips.configure ([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }

}

#Preview("Empty") {
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
    private let editingTip = EditingExpensesTip()


    var body: some View {
        NavigationStack {

            
            List {
                Section {
                    TipView(editingTip)
                        .tipBackground(.teal.opacity(0.2))
                        .listRowBackground(Color.clear)
                    
                        /// add resizing
                        /// This Rectangle will take up 100% of the width
                        /// of its nearest container (the Section/List in this case).
                        .containerRelativeFrame(.horizontal) { length, axis in
                            length * 1.0 // Takes 100% of the width
                        }

                }
                
                    ForEach(expenses) { obj in
                        ExpenseCell(expense: obj)
                            .onTapGesture {
                                expenseToEdit = obj
                                Task { await EditingExpensesTip.editExpenseEvent.donate() }
                            }
                    }
                
                /// swipe to delete action
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(expenses[index])
                    }
                }
            }
            .listSectionSpacing(.compact)
            
            .onAppear {
                Task { await EditingExpensesTip.listViewOpenedEvent.donate() }
                
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
                        addExpenseTip.invalidate(reason: .actionPerformed)
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

