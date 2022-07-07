//
//  SigninRespons.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/08.
//

import Foundation

struct SigninResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var username: String?
    var userid: String?
}
