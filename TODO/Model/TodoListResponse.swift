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
    var data: [findedTodo]
}

struct findedTodo: Decodable {
    
    var title: String
    var content: String
    var id: String
    var date: String
    
}
