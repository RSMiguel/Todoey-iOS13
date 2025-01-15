//
//  Item.swift
//  Todoey
//
//  Created by Miguel Angel Reyes Sánchez on 14/01/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
