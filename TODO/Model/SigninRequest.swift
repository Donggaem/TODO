//
//  SigninRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/08.
//

import Foundation

struct SigninRequest: Encodable {
    var username: String
    var userid: String
    var userpw: String
    var userpw_check: String
}
