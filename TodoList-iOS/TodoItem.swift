//
//  TodoItem.swift
//  TodoList-iOS
//
//  Created by Robert Dickerson on 5/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation

struct TodoItem: Comparable {
    
    let id: String
    let title: String
    var completed: Bool
    var order: Int
    
    var jsonRepresentation : String {
        // facebook credentials version
        // return "{\"title\":\"\(title)\",\"completed\":\"\(completed)\",\"order\":\"\(order)\"}"
        return "{\"uid\":\"\(User.facebookUserId)\",\"title\":\"\(title)\",\"completed\":\"\(completed)\",\"order\":\"\(order)\"}"
    }
    
}

func < (lhs: TodoItem, rhs: TodoItem) -> Bool {
    return lhs.order < rhs.order
}

func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
    return lhs.order == rhs.order
}