//
//  UpdateTodoResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/14.
//

import Foundation

struct UpdateTodoResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
}
