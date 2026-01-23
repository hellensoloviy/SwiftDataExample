//
//  EditingExpensesTip.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 22.01.2026.
//

import Foundation
import TipKit


struct EditingExpensesTip: Tip {
    
    static let listViewOpenedEvent = Event(id: "listViewOpenedEvent")
    static let editExpenseEvent = Event(id: "editExpenseEvent")

    var title: Text {
        Text("Edit your expenses")
    }
    
    var message: Text? {
        Text("You can edit expense by tap and hold on the expense")
    }
    
    var rules: [Rule] {
        #Rule(Self.listViewOpenedEvent) { event in
            event.donations.count > 5 /// just a random number to test
        }
        #Rule(Self.editExpenseEvent) { event in
            event.donations.count == 0
        }
    }
    
}
