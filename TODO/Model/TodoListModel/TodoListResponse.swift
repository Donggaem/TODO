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
    var data: todo?
}

struct todo: Decodable {
    
    var findedTodo: [Object]

}

struct Object: Decodable {
    
    var id: String
    var date: String
    var title: String
    var content: String
}
