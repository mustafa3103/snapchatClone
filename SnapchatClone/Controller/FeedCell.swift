//
//  FeedCell.swift
//  SnapchatClone
//
//  Created by Mustafa on 18.07.2022.
//

import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var feedUsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
