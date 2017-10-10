//
//  SearchTableViewCell.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/08.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var placeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
