//
//  ViewController.swift
//  SmartHome
//
//  Created by Савелий Вепрев on 26/05/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//



import UIKit
import Starscream


class ViewController: UIViewController, WebSocketDelegate {

    var socket: WebSocket?
    var message: CableLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(request: self.headers() )
        socket!.delegate = self
    }
    
    @IBAction func connect(_ sender: Any) {
        socket!.connect()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let mes = (message?.send(id: "1", action: "receive", value: "Диалог убийц"))!
        socket!.write(string: mes)
    }
    
    func headers() -> URLRequest {
        var request = URLRequest(url: URL(string: "ws://localhost:3000/cable")!)
        request.setValue("token bmFrYXphbi5ydUBnbWFpbC5jb206dENvcHpvQWNUekpmbjJ0SHd3Vm4=", forHTTPHeaderField: "Authorization")
        request.setValue("nakazan.ru@gmail.com", forHTTPHeaderField: "X-Authorization-Email")
        return request
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        message = CableLayer(channel: "ConversationChannel")
        let sub = (message?.subscribe(id: "1"))!
        socket.write(string: sub)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect", error ?? "")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage", text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData", data)
    }
}
class CableLayer {
    
    let channel: String
    
    init(channel: String) {
        self.channel = channel
    }    
    func subscribe(id: String) -> String {
        
        let identifier : [String: Any] = [
            "channel": self.channel,
            "id": id
        ]
        let jsonIdent = identifier.JSONStringify()
        let messageDictionary : [String: Any] = [
            "command": "subscribe",
            "identifier": jsonIdent
        ]
        let jsonString = messageDictionary.JSONStringify()
        
        return jsonString
    }
    func send(id: String, action: String, value: String ) -> String{
        let mes : [String: Any] = [
            "channel": self.channel,
            "id": id
        ]
        let jsonMes = mes.JSONStringify()
        let actionArg : [String: Any] = [
            "action": action,
            "value": value
        ]
        let jsonActionArg = actionArg.JSONStringify()
        let mesDict : [String: Any] = [
            "command": "message",
            "identifier": jsonMes,
            "data": jsonActionArg,
        ]
        let jsonSender = mesDict.JSONStringify()
        print ("отправил", jsonSender)
        
        return jsonSender
    }
}
extension Dictionary {
    func JSONStringify() -> String{
        if JSONSerialization.isValidJSONObject(self) {
            do{
                let data = try JSONSerialization.data(withJSONObject: self, options: [])
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                print("error JSONStringify() ")
            }
        }
        return ""
    }
}

