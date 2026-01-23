//
//  AddExpenseTip.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 22.01.2026.
//

import Foundation
import TipKit

struct AddExpenseTip: Tip {
    
    var title: Text {
        Text("Add new expense")
            .foregroundStyle(.teal)
    }
    
    var message: Text? {
        Text("You add more expenses using this button")
    }
    
    var image: Image? {
        Image(systemName: "plus")
    }
}
