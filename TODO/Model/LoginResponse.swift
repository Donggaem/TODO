//
//  LoginResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/03.
//

import Foundation

//로그인 Response 서버에서 받아오는 값
struct LoginResponse: Decodable {
   
    var isSuccess: Bool
    var code: Int
    var message: String
    var data: token
}

struct token: Decodable{
    var token: String
}
