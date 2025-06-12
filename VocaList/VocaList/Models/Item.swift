// 20250605
// Item Data Model

// @Model triggers scheme generation
// transforms the class' stored properties into persisted ones
// makes the class conform to Observable for reactivity
// "This class should be saved to the DB"

import Foundation
import SwiftData

@Model
class Item {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date
    var sortOrder: Int
    
//    // this is what SwiftData actually stores (primitive types)
//    var categoryRawValue: String
//    
//    //*REVISIT THIS LOGIC on Claude
//    // this is what we use to interact with the enum and ultimately set categoryRawValue to the end to save to SwiftData
//    // category is of enum type ItemCategory
//    // Computed Property
//    var category: ItemCategory {
//        get {
//            ItemCategory(rawValue: categoryRawValue) ?? .personal
//        }
//        set {
//            // newValue is built into setter to change
//            // rawValue is built in for enums - to get raw value (ex: String)
//            categoryRawValue = newValue.rawValue
//        }
//    }
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date() // sets date when object is created
        self.completedAt = Date()
//        self.categoryRawValue = category.rawValue
        self.sortOrder = Int(Date().timeIntervalSince1970)
    }
}
