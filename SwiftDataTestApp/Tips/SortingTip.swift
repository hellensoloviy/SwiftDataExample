//
//  SortingTip.swift
//  SwiftDataTestApp
//
//  Created by Hellen Soloviy on 22.01.2026.
//

import Foundation
import TipKit

struct SortingTip: Tip {
    
    var title: Text {
        Text("Sort results")
    }
    
    var message: Text? {
        Text("You can sort results by value")
    }
    
}
