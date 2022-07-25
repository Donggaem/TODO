//
//  SigninRequest.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/08.
//

import Foundation

struct SigninRequest: Encodable {
    
    var user_name: String
    var user_id: String
    var user_pw: String
    var user_confirmPw: String
    
}
