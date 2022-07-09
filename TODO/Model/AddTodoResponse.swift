//
//  AddTodoResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/09.
//

import Foundation

struct AddTodoResponse: Decodable {
    
    var isSuccess: Bool
    var code: Int
    var message: String
    
}
