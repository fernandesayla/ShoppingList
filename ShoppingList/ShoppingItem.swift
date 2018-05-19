//
//  ShoppingItem.swift
//  ShoppingList
//
//  Created by Ayla Fernandes on 5/19/18.
//  Copyright © 2018 FIAP. All rights reserved.
//

import Foundation
import Firebase

class ShoppingItem {
    
    var name: String
    var quantity: Int
    var document: QueryDocumentSnapshot
    
    init(name: String, quantity: Int, document: QueryDocumentSnapshot) {
        self.name = name
        self.quantity = quantity
        self.document = document
    }
}
