//
//  DeleteTodoRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/10.
//

import Foundation

struct DeleteTodoRequest: Encodable {
    
    var id: String//삭제할 Todo의 UUID
}
