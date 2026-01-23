//
//  SwiftDataTestAppApp.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 21.01.2026.
//

import SwiftUI
import SwiftData
import TipKit

@main
struct SwiftDataTestAppApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([Expense.self])
        let container = try! ModelContainer(for: schema, configurations: []) /// no need for  any additional configuration as an example
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ExpensesListView(viewModel: .init())
                .modelContainer(container)
                .task {
                    try? Tips.configure([
//                        .displayFrequency(.immediate), /// just to test
                        .datastoreLocation(.applicationDefault)
                    ])
                }
                
        }
    }
}
