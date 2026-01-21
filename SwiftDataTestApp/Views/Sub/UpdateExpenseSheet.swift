//
//  UpdateExpenseSheet.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI

struct UpdateExpenseSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense: Expense

    var body: some View {
        NavigationStack{
            Form {
                TextField("Expense name", text: $expense.name)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        /// close the sheet, no any action needed because of the Bindable state of our object
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    UpdateExpenseSheet(expense: .init(name: "Name2", date: .now, value: 33))
}
