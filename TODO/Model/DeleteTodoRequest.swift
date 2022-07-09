//
//  DeleteTodoRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/10.
//

import Foundation

struct DeleteTodoRequest: Encodable {
    
    var no: Int
    var userid: String
}
