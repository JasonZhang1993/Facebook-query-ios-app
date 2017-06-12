//
//  SearchTableViewCell.swift
//  FB Search
//
//  Created by Jason Zhang on 4/11/17.
//  Copyright © 2017 Jason Zhang. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePhoto: UIImageView!

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var favorite: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
