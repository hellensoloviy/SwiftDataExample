//
//  ExpensesListViewModel.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 22.01.2026.
//

import Foundation
import SwiftUI
import SwiftData


extension ExpensesListView {
    
    class ViewModel: ObservableObject {
        @Environment(\.modelContext) private var modelContext

        
    }
    
    
}

//MARK: - Actions
extension ExpensesListView.ViewModel {
    
    func sortResultsActionTapped() {
        //TODO: - sort action
    }
    

}
