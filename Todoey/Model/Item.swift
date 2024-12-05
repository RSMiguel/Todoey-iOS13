//
//  Item.swift
//  Todoey
//
//  Created by Miguel Angel Reyes Sánchez on 21/11/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
    
    init(title: String){
        self.title = title
    }
}
