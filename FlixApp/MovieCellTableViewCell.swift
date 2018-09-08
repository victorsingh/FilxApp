//
//  MovieCellTableViewCell.swift
//  FlixApp
//
//  Created by Victor Singh on 9/7/18.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit

class MovieCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
