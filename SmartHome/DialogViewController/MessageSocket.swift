//
//  Message.swift
//  SmartHome
//
//  Created by Савелий Вепрев on 31/05/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//

import Foundation
//{"identifier":"{\"id\":\"22\",\"channel\":\"ConversationChannel\"}","message":{"action":"receive","value":"435435"}}
import Foundation
struct MessageSocket: Codable {
    let identifier: Identifier
    let message: Message
}
struct Identifier: Codable{
    let id: String
    let channen: String   
}
struct Message: Codable{
    let action: String
    let value: String
}

