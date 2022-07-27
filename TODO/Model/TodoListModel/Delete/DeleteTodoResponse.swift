//
//  DeleteTodoResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/10.
//

import Foundation

struct DeleteTodoResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: DeletedTodo?
}
struct DeletedTodo: Decodable {
    var deletedTodo: Dobject
}


struct Dobject: Decodable {
    
    var date: String
    var title: String
    var content: String
    
}
