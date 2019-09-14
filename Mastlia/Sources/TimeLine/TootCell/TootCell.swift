//
//  TootCell.swift
//  Mastlia
//
//  Created by ymgn on 2018/11/23.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit
import RealmSwift

class TootCell: UITableViewCell {
    var user: Account = Account()
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var tootContent: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var repCount: UILabel!
    @IBOutlet weak var retCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    var isFavorited = false
    var isRebloged = false
    var id: String = ""
    
    func judge() {
        if isFavorited {
            starButton.tintColor = UIColor.yellow
        } else {
            starButton.tintColor = UIColor.black
        }
        if isRebloged {
            retweetButton.tintColor = UIColor.green
        } else {
            retweetButton.tintColor = UIColor.black
        }
    }
    
    @IBAction func onReplyTapped(_ sender: Any) {
    }
    @IBAction func onBoostTapped(_ sender: Any) {
        if !isRebloged {
            var client = Client(baseURL: "https://" + user.domain)
            client.accessToken = user.accessToken
            let req = Statuses.reblog(id: id)
            client.run(req) { result in
                if let res = result.value {
                    self.isRebloged = true
                    DispatchQueue.main.async {
                        self.retweetButton.tintColor = UIColor.green
                    }
                    print(res)
                    return
                } else {
                    print(result)
                    return
                }
            }
            return
        }
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        let req = Statuses.unreblog(id: id)
        client.run(req) { result in
            if let res = result.value {
                self.isRebloged = false
                DispatchQueue.main.async {
                    self.retweetButton.tintColor = UIColor.black
                }
                print(res)
                return
            } else {
                print(result)
                return
            }
        }
    }
    @IBAction func onFavTapped(_ sender: Any) {
        if !isFavorited {
            let req = Statuses.favourite(id: id)
            var client = Client(baseURL: "https://" + user.domain)
            client.accessToken = user.accessToken
            client.run(req) { result in
                if let res = result.value {
                    self.isFavorited = true
                    DispatchQueue.main.async {
                        self.starButton.tintColor = UIColor.yellow
                    }
                    print(res)
                    return
                } else {
                    print(result)
                    return
                }
            }
            return
        }
        let req = Statuses.unfavourite(id: id)
        var client = Client(baseURL: "https://" + user.domain)
        client.accessToken = user.accessToken
        client.run(req) { result in
            if let res = result.value {
                self.isFavorited = false
                DispatchQueue.main.async {
                    self.starButton.tintColor = UIColor.black
                }
                print(res)
                return
            } else {
                print(result)
                return
            }
        }
        return
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if isFavorited {
            starButton.tintColor = UIColor.yellow
        }
        if isRebloged {
            retweetButton.tintColor = UIColor.green
        }
    }
    
}
