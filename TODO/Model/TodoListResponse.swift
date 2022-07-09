//
//  TodoListResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/10.
//

import Foundation

struct TodoListResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var todo: [TodoList]
}

struct TodoList: Decodable {
    
    var no: Int
    var title: String
    var content: String
    var userid: String
    var date: String
    
}
