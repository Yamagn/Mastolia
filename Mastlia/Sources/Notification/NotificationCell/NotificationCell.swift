//
//  NotificationCell.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/05.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var fromUserAvatar: UIImageView!
    @IBOutlet weak var notificationDiscription: UILabel!
    @IBOutlet weak var tootContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func judge(type type: NotificationType, UserName name: String) {
        if type == .favourite {
            typeImage.image = UIImage(named: "star.png")!
            typeImage.tintColor = UIColor.yellow
            notificationDiscription.text = name + "さんにふぁぼされました"
        } else if type == .reblog {
            typeImage.image = UIImage(named: "retweet.png")!
            typeImage.tintColor = UIColor.green
            notificationDiscription.text = name + "さんにブーストされました"
        } else if type == .follow {
            typeImage.image = UIImage(named: "person_add.png")!
            typeImage.tintColor = UIColor.blue
            notificationDiscription.text = name + "さんにフォローされました"
            tootContent.text = ""
        } else {
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
