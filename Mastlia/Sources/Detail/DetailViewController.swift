//
//  DetailViewController.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/04.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var detailTable: UITableView!
    var replys: [Mention] = []
    var catchToot: Status? = nil
    var user: Account = Account()
    var isCount = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainNib = UINib(nibName: "DetailCell", bundle: nil)
        let countNib = UINib(nibName: "ActivityCountCell", bundle: nil)
        let activityNib = UINib(nibName: "ActivityCell", bundle: nil)
        let tootNib = UINib(nibName: "TootCell", bundle: nil)
        
        detailTable.register(mainNib, forCellReuseIdentifier: "DetailCell")
        detailTable.register(countNib, forCellReuseIdentifier: "ActivityCountCell")
        detailTable.register(activityNib, forCellReuseIdentifier: "ActivityCell")
        detailTable.register(tootNib, forCellReuseIdentifier: "TootCell")
        
        detailTable.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && !isCount {
            return 0
        }
        return detailTable.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        guard let toot = catchToot  else{
            let cell = UITableViewCell()
            return cell
        }
        replys = toot.mentions
        switch indexPath.row {
        case 0:
            let cell: DetailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailCell
            cell.userAvater.setImage(fromUrl: toot.account.avatar)
            cell.userID.text = "@" + toot.account.username
            cell.userName.text = toot.account.displayName
            cell.dateTime.text = formatter.string(from: toot.createdAt)
            let attributedString = NSAttributedString.parseHTML2Text(sourceText: "<b><font size=5>" + toot.content + "</b>")
            cell.tootContent.attributedText = attributedString
            return cell
        case 1:
            let cell: ActivityCountCell = tableView.dequeueReusableCell(withIdentifier: "ActivityCountCell") as! ActivityCountCell
            if toot.reblogsCount > 0 {
                cell.boostCount.text = String(toot.reblogsCount) + "件のブースト"
            } else {
                cell.boostCount.text = ""
                cell.boostCount.isHidden = true
            }
            
            if toot.favouritesCount > 0 {
                cell.favCount.text = String(toot.favouritesCount) + "件のふぁぼ"
            } else {
                cell.favCount.text = ""
            }
            
            if cell.boostCount.text! == "" && cell.favCount.text! == "" {
                cell.isHidden = true
                isCount = false
            }
            
            return cell
        case 2:
            let cell: ActivityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
            
            return cell
        default:
            let cell: TootCell = tableView.dequeueReusableCell(withIdentifier: "TootCell", for: indexPath) as! TootCell
            
            if replys.isEmpty {
                cell.isHidden = true
                return cell
            }

            let data = replys[indexPath.row - 3]
            print(data)
//            cell.retCount.text = String(data.reblogsCount)
//            cell.repCount.text = String(data.mentions.count)
//            cell.favCount.text = String(data.favouritesCount)
//            //        cell.tootContent.text = data.content
//            let attributedString = NSAttributedString.parseHTML2Text(sourceText: "<b><font size=5>" + data.content + "</b>")
//            cell.tootContent.attributedText = attributedString
//            cell.userID.text = "@" + data.account.username
//            cell.userName.text = data.account.displayName
//            print(data.account.avatar)
//            cell.userImage.setImage(fromUrl: data.account.avatar)
//            cell.id = data.id
//            cell.user.domain = self.user.domain
//            cell.user.accessToken = self.user.accessToken
//            cell.isFavorited = data.favourited ?? false
//            cell.isRebloged = data.reblogged ?? false
//            cell.judge()
            return cell
        }
    }

}
