//
//  ResignResponse.swift
//  TODO
//
//  Created by 김동겸 on 2022/07/27.
//

import Foundation

struct ResignResponse: Decodable{
    
    var isSuccess: Bool
    var code: Int
    var message: String
}
