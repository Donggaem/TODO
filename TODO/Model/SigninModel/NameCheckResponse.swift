//
//  NameCheckResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/29.
//

import Foundation

struct NameCheckResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
    
}
