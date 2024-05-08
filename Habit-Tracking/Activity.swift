//
//  Activity.swift
//  Habit-Tracking
//
//  Created by Leo Torres Neyra on 21/1/24.
//

import Foundation

struct Activity: Codable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var name : String
    var description: String
    var count: Int = 0
    var isChecked: Bool = false
    
}

