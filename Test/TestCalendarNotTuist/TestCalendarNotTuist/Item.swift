//
//  Item.swift
//  TestCalendarNotTuist
//
//  Created by 고요한 on 6/19/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
