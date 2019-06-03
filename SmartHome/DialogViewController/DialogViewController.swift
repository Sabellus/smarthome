//
//  DialogViewController.swift
//  SmartHome
//
//  Created by Савелий Вепрев on 31/05/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//

import UIKit

import Starscream
import SwiftyJSON
class DialogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,WebSocketDelegate {
    static func storyboardInstance() -> DialogViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? DialogViewController
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    var socket: WebSocket?
    var message: CableLayer?    
    var dialog = DialogModel()
    
   
    var idDialog: String? = ""
    var idUser: String? = ""
    
    
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect", error ?? "")
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage", text)
        let json = JSON.init(parseJSON:text)
        var mes = json.dictionary
//        var mes = text.convertToDictionary()
        if let _ = mes?["identifier"], let message = mes?["message"] {
            var isMy = true
            let value = message["value"].rawString()!
            let email = message["email"].rawString()!
            if email != storage.userInfo.email{
                isMy = false
            }
            // let identDict = (identifier as! String).convertToDictionary()
            // let mesDict = (message as! String).convertToDictionary()
            let newMes = DialogModel.Message(id: 1, autor: "Я", value: value, dt: "18:30", isMy: isMy)
            dialog.messages.insert(newMes, at: 0)
            tableView.reloadData()
            
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData", data)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = WebSocket(request: self.headers() )
        socket!.delegate = self
        socket?.connect()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DialogMessageCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        tableView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        getMessages()
    }
    func getMessages(){
        let headers: [String : String] = [
            "Content-Type": "application/json",
            "Authorization": storage.userInfo.token_t,
            "X-Authorization-Email": storage.userInfo.email
        ]
        network.fetch(fromRoute: Routes.supportConversations, fromParameters: nil, fromHeaders: headers) { (result) in
            switch result {
            case .success(let model):
                
                print(model)
                model.forEach({ element in
                    if element.status == "inprogress" || element.status == "created" {
                        self.idDialog! = String(element.id!)
                    }
                    element.messages.forEach({ el in
                        self.dialog.messages.insert(DialogModel.Message(id: el?.id!, autor: (el?.user?.last_name!)!+" "+(el?.user?.first_name!)!, value: el?.value!, dt: "18:30", isMy: (el?.user?.is_my!)!), at: 0)
                    })
                })
                self.subscribe()
                self.tableView.reloadData()
            case .failure(let error):
                print (error)
            }
        }
    }
    func subscribe(){
        if self.idDialog! != "" {
            message = CableLayer(channel: "ConversationChannel")
            let sub = (message?.subscribe(id: String(self.idDialog!)))!
            socket!.write(string: sub)
        }
    }
    func headers() -> URLRequest {
        let token = "token "+storage.userInfo.token
        var request = URLRequest(url: URL(string: "ws://localhost:3334/cable")!)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue(storage.userInfo.email, forHTTPHeaderField: "X-Authorization-Email")
        
        return request
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialog.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DialogMessageCell
        let chatMessage = dialog.messages[indexPath.row]
        cell.chatMessage = chatMessage
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionSelectImageAddButton))
        singleTap.numberOfTapsRequired = 1
        cell.messageImageView.tag = indexPath.row
        cell.messageImageView.isUserInteractionEnabled = true
        cell.messageImageView.addGestureRecognizer(singleTap)
        return cell
    }
    func newDialog(value:String, closure: @escaping () -> Void) {
        let headers: [String : String] = [
//            "Content-Type": "application/json",
            "Authorization": storage.userInfo.token_t,
            "X-Authorization-Email": storage.userInfo.email
        ]
        let parameters: [String : String] = [
            "value": value,
        ]
        network.fetch(fromRoute: Routes.supportConversationsCreate, fromParameters: parameters, fromHeaders: headers) { (result) in
            switch result {
            case .success(let model):
                
                print(model)
                model.forEach({ element in
                    if element.status == "inprogress" || element.status == "created" {
                         self.idDialog! = String(element.id!)
                    }
                    element.messages.forEach({ el in
                        self.dialog.messages.insert(DialogModel.Message(id: el?.id!, autor: (el?.user?.last_name!)!+" "+(el?.user?.first_name!)!, value: el?.value!, dt: "18:30", isMy: (el?.user?.is_my!)!), at: 0)
                    })
                })
                self.subscribe()
                self.tableView.reloadData()
                closure()
            case .failure(let error):
                print (error)
            }
        }
    }
    func someFunctionWithNonescapingClosure(closure: () -> Void) {
        closure()
    }
    @IBAction func sendMessage(_ sender: Any) {
        let mes = String(messageTextField.text!)
        let valueSend = [
            "value": mes,
            "email": storage.userInfo.email
        ]
        let jsonValue = JSON(valueSend)
        let strValue = jsonValue.rawString()
        
        if  self.idDialog! == "" {
            self.newDialog(value: mes, closure: {
                let mesSocket = (self.message?.send(id: self.idDialog!, action: "receive", value: strValue!))!
                self.socket!.write(string: mesSocket)
            })
        }
        else{
            let mesSocket = (message?.send(id: self.idDialog!, action: "receive", value: strValue!))!
            socket!.write(string: mesSocket)
        }
    }
    
    @objc func actionSelectImageAddButton(){
    
    }

}
class CableLayer {
    
    let channel: String
    var identifier: String!
    
    init(channel: String) {
        self.channel = channel
    }
    func subscribe(id: String) -> String {
        
        let identifier : [String: Any] = [
            "channel": self.channel,
            "id": id
        ]
        let jsonIdent = identifier.JSONStringify()
        self.identifier = jsonIdent
        let messageDictionary : [String: Any] = [
            "command": "subscribe",
            "identifier": self.identifier
        ]
        let jsonString = messageDictionary.JSONStringify()
        
        return jsonString
    }
    func send(id: String, action: String, value: String ) -> String{
        let id = id
        let channel = self.channel
        // {"id":"1","channel":"ConversationChannel"}
        let actionArg : [String: Any] = [
            "action": action,
            "value": value
        ]
        let jsonActionArg = actionArg.JSONStringify()
        let mesDict : [String: Any] = [
            "command": "message",
            //"identifier": "{\"id\":\"\(id)\",\"channel\":\"\(channel)\"}",
            //"identifier": "{\"channel\":\"\(channel)\",\"id\":\"\(id)\"}",
            "identifier": self.identifier,
            "data": jsonActionArg,
        ]
        let jsonSender = mesDict.JSONStringify()
        print ("отправил", jsonSender)
        
        return jsonSender
    }
}

