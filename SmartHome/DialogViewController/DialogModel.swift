//
//  ChatModel.swift
//  KortrosNativ
//
//  Created by Савелий Вепрев on 29/01/2019.
//  Copyright © 2019 Yunikorn. All rights reserved.
//

import Foundation
class DialogModel {
    var selectedDialogId: String = ""
    struct Message {
        var id: Int!
        var autor: String!
        var value: String!
        var dt: String!
        var isMy: Bool!
    }
    var messages: [Message] = []    
}
