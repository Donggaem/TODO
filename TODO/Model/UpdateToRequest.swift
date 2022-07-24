//
//  UpdateToRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/14.
//

import Foundation

struct UpdateTodoRequest: Encodable{
    
    var id: String
    var date: String
    var title: String
    var content: String

}
