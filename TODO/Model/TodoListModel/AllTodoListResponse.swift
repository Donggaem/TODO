//
//  AllTodoListResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/24.
//

import Foundation

struct AllTodoListResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: AllTodo?
}

struct AllTodo: Decodable {
    
    var findedAllTodo: [AllObject]
}

struct AllObject: Decodable {
    
    var date: String
}
