//
//  DetailMovieCell.swift
//  icf-books
//
//  Created by Andreas Plüss on 24.03.16.
//  Copyright © 2016 devkitchen. All rights reserved.
//

import UIKit

class DetailMovieCell: UITableViewCell {
    
    @IBOutlet weak var detailMovieThumb: UIImageView!
    @IBOutlet weak var detailMovieUrl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
