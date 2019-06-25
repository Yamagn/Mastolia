//
//  UserViewController.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/27.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit
import RealmSwift

class UserViewController: UIViewController {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var avater: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var followCount: UIButton!
    @IBOutlet weak var followersCount: UIButton!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var account: MastodonKit.Account?
    var current: MastodonKit.Account?
    
    var userlist: [MastodonKit.Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let user = realm.objects(Account.self).first!
        let infoReq = Accounts.currentUser()
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        if self.account == nil {
            client.run(infoReq) { result in
                if let current = result.value {
                    self.current = current
                    self.account = current
                    guard let account = self.current else {
                        let controller = UIAlertController(title: nil, message: "情報を取得できませんでした", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(controller, animated: true, completion: nil)
                        return
                    }
                    DispatchQueue.main.async {
                        self.avater.setImage(fromUrl: account.avatar)
                        self.headerImage.setImage(fromUrl: account.header)
                        self.userName.text = account.displayName
                        self.screenName.text = "@" + account.username
                        self.followCount.setTitle("\(account.followingCount)フォロー", for: .normal)
                        self.followersCount.setTitle("\(account.followersCount)フォロワー", for: .normal)
                        let attributedString = account.note.convertHTML(withFont: UIFont.systemFont(ofSize: 20.0), align: .left)
                        self.note.attributedText = attributedString
                    }
                }
            }
        } else {
            client.run(infoReq) { result in
                if let current = result.value {
                    self.current = current
                    guard let account = self.account else {
                        let controller = UIAlertController(title: nil, message: "情報を取得できませんでした", preferredStyle: .alert)
                        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(controller, animated: true, completion: nil)
                        return
                    }
                    DispatchQueue.main.async {
                        self.avater.setImage(fromUrl: account.avatar)
                        self.headerImage.setImage(fromUrl: account.header)
                        self.userName.text = account.displayName
                        self.screenName.text = "@" + account.username
                        self.followCount.setTitle("\(account.followingCount)フォロー", for: .normal)
                        self.followersCount.setTitle("\(account.followersCount)フォロワー", for: .normal)
                        let attributedString = account.note.convertHTML(withFont: UIFont.systemFont(ofSize: 20.0), align: .left)
                        self.note.attributedText = attributedString
                    }
                }
            }
        }
        if self.account?.id == self.current?.id {
            followButton.setTitle("設定", for: .normal)
            followButton.backgroundColor = UIColor.gray
        } else {
            let relationshipReq = Accounts.relationships(ids: [self.account!.id])
            client.run(relationshipReq) { result in
                if let relation = result.value {
                    if relation.first!.following {
                        DispatchQueue.main.async {
                            self.followButton.setTitle("フォローを外す", for: .normal)
                            self.followButton.backgroundColor = UIColor.red
                            self.followButton.setTitleColor(.white, for: .normal)
                        }
                    }
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStatuses" {
            let userStatusesView: UserStatusesViewController = segue.destination as! UserStatusesViewController
            userStatusesView.param = self.account
        } else if segue.identifier == "showUserList" {
            let userListView: UserListViewController = segue.destination as! UserListViewController
            userListView.accounts = userlist
        }
    }
    
    
    @IBAction func moveFollowList(_ sender: Any) {
        let realm = try! Realm()
        let user = realm.objects(Account.self).first!
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        if let acc = self.account {
            let fllowingReq = Accounts.following(id: acc.id, range: .default)
            client.run(fllowingReq) { result in
                if let list = result.value {
                    self.userlist = list
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showUserList", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func moveFollwerList(_ sender: Any) {
        let realm = try! Realm()
        let user = realm.objects(Account.self).first!
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        if let acc = self.account {
            let fllowerReq = Accounts.followers(id: acc.id, range: .default)
            client.run(fllowerReq) { result in
                if let list = result.value {
                    self.userlist = list
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showUserList", sender: nil)
                    }
                }
            }
        }
    }
    @IBAction func viewTweets(_ sender: Any) {
    }
    @IBAction func followUser(_ sender: Any) {
        let realm = try! Realm()
        let user = realm.objects(Account.self).first!
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        if followButton.currentTitle == "フォローする" {
            let followReq = Accounts.follow(id: account!.id)
            client.run(followReq) { result in
                print(result)
                DispatchQueue.main.async {
                    self.followButton.setTitle("フォローを外す", for: .normal)
                    self.followButton.backgroundColor = UIColor.red
                    self.followButton.setTitleColor(.white, for: .normal)
                }
            }
        }
        if followButton.currentTitle == "フォローを外す" {
            let unfollowReq = Accounts.unfollow(id: account!.id)
            client.run(unfollowReq) { result in
                DispatchQueue.main.async {
                    self.followButton.setTitle("フォローする", for: .normal)
                    self.followButton.backgroundColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
                    self.followButton.setTitleColor(.white, for: .normal)
                }
            }
        } else {
            performSegue(withIdentifier: "showSetting", sender: nil)
        }
    }
}
