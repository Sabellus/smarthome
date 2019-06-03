//
//  RoomListViewController.swift
//  ChatSup
//
//  Created by Савелий Вепрев on 29/05/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//

import UIKit
import SwiftyJSON
class RoomListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let chats: [String] = ["Техническая поддержка"]    
    let cellReuseIdentifier = "cell"
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Чаты"
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        let someButton = UIButton()
        someButton.setTitle("Выход", for: .normal)
        someButton.setTitleColor(.black, for: .normal)
        someButton.addTarget(self, action: #selector(back_btn), for: .touchUpInside)
        someButton.showsTouchWhenHighlighted = true
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        self.navigationItem.leftBarButtonItem = mailbutton
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    @objc func back_btn(){
        UserDefaults.standard.set(nil, forKey: "token")
        UserDefaults.standard.set(nil, forKey: "email")
        Switcher.updateRootVC()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = self.chats[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let dialog = DialogViewController.storyboardInstance()
        dialog!.dialog.selectedDialogId = String(indexPath.row)
        dialog?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dialog!, animated: true)
    }
}
