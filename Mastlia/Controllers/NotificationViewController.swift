//
//  NotificationViewController.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/05.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit
import RealmSwift

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var dataList: [MastodonKit.Notification] = []
    var user: Account = Account()
    var selectContent: MastodonKit.Notification?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataList[indexPath.row]
        let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.fromUserAvatar.setImage(fromUrl: data.account.avatar)
        if let status = data.status {
            let attributedString = status.content.convertHTML(withFont: UIFont.systemFont(ofSize: 30.0), align: .left)
            cell.tootContent.attributedText = attributedString
        }
        cell.judge(type: data.type, UserName: data.account.username)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserInfo" {
            let userInfoController: UserViewController = segue.destination as! UserViewController
            userInfoController.account = self.selectContent?.account
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectContent = dataList[indexPath.row]
        if selectContent != nil {
            if selectContent?.type == NotificationType.follow {
                performSegue(withIdentifier: "showUserInfo", sender: nil)
            }
        }
    }
    
    func reloadListDatas() {
        let req = Notifications.all()
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        client.run(req) { result in
            if let notys = result.value {
                self.dataList = notys
                print(notys)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                let controller = UIAlertController(title: nil, message: "通知を取得できませんでした", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let users = realm.objects(Account.self)
        user = users[0]
        if users.count == 0 {
            performSegue(withIdentifier: "moveLoginView", sender: nil)
            return
        }
        
        let notifyNib = UINib(nibName: "NotificationCell", bundle: nil)
        let tootNib = UINib(nibName: "TootCell", bundle: nil)
        tableView.register(notifyNib, forCellReuseIdentifier: "NotificationCell")
        tableView.register(tootNib, forCellReuseIdentifier: "TootCell")
        
        reloadListDatas()
    }

}
