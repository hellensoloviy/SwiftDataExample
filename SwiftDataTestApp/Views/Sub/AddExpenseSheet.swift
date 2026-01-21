//
//  AddExpenseSheet.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI

#Preview {
    AddExpenseSheet()
}

struct AddExpenseSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var value: Double = 0

    var body: some View {
        NavigationStack{
            Form {
                TextField("Expense name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        //TODO: - save code here
                    }
                }
            }
        }
    }
}


