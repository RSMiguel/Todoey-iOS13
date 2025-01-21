//
//  Category.swift
//  Todoey
//
//  Created by Miguel Angel Reyes Sánchez on 14/01/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var items = List<Item>()
    @Persisted var color: String = FlatWhite().hexValue()
}
