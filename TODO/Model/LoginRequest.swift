//
//  LoginRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/03.
//

import Foundation

//로그인 Requset 서버에 주는값
struct LoginRequest: Encodable {
    var userid: String
    var userpw: String
}
