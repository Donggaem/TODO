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
    
}
