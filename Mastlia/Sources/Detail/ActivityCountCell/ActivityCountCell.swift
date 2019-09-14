//
//  ActivityCountCell.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/04.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class ActivityCountCell: UITableViewCell {

    @IBOutlet weak var boostCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
