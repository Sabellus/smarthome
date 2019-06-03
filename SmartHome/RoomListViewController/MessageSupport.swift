//
//  RoomModel.swift
//  SmartHome
//
//  Created by Савелий Вепрев on 01/06/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//

import Foundation

struct MessageSupport: Codable {
    var id: Int?
    var messages: [MessageRoom?]
    var status: String?
    var updated_at: String?  
}
struct MessageRoom: Codable {
    var id: Int?
    var value: String?
    var user: UserRoom?
    
}
struct UserRoom: Codable {
    var id: Int?
    var email: String?
    var first_name: String?
    var last_name: String?
    var gender: String?
    var phone: String?
    var address: String?
    var created_at: String?
    var is_my: Bool?
}

