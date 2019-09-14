//
//  DetailCell.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/04.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet weak var userAvater: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var tootContent: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
