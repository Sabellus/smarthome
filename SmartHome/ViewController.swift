//
//  ViewController.swift
//  SmartHome
//
//  Created by Савелий Вепрев on 26/05/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//



import UIKit
import Starscream
import UserNotifications

class ViewController: UIViewController, WebSocketDelegate {

    static func storyboardInstance() -> ViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ViewController
    }
    var socket: WebSocket?
    var message: CableLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(request: self.headers() )
        socket!.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            
        })
    }
    
    @IBAction func connect(_ sender: Any) {
        socket!.connect()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let mes = (message?.send(id: "1", action: "receive", value: "Диалог убийц"))!
        socket!.write(string: mes)
      
       
    }
    
    func headers() -> URLRequest {
        var request = URLRequest(url: URL(string: "ws://localhost:3334/cable")!)
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
        let content = UNMutableNotificationContent()
        content.title = "The 5 seconds are up"
        content.subtitle = "КУКУ"
        content.body = text
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "timerDone", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData", data)
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

