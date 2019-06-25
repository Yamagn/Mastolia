//
//  SettingViewController.swift
//  Mastlia
//
//  Created by ymgn on 2019/06/22.
//  Copyright © 2019 ymgn. All rights reserved.
//

import UIKit
import MastodonKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var settingTableView: UITableView!
    let settingContents: [String] = ["ユーザ設定"]
    let appContents: [String] = ["開発者(Twitter)", "ソースコード", "バグ報告", "レビューする"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定"
        let nib = UINib(nibName: "SettingCell", bundle: nil)
        settingTableView.register(nib, forCellReuseIdentifier: "SettingCell")
        settingTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return settingContents.count
        } else {
            return appContents.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "マストドン設定"
        } else {
            return "アプリについて"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        if indexPath.section == 0 {
            cell.content.text = settingContents[indexPath.row]
        } else {
            cell.content.text = appContents[indexPath.row]
        }
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    

}
