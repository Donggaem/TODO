//
//  AddTodoRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/09.
//

import Foundation

struct AddTodoRequest: Encodable {
    
    var title: String
    var content: String
//    var userid: String
    var date: String
    
}
