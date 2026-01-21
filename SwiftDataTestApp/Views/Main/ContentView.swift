//
//  ContentView.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI

#Preview {
    ContentView()
}

struct ContentView: View {
    
    @State private var isShowingItemSheet: Bool = false
    var expenses: [Expense] = []
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(expenses) { obj in
                    ExpenseCell(expense: obj)
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddExpenseSheet()
            }
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

