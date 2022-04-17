//
//  FavourtiteTableViewCell.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 17/04/2022.
//

import UIKit

class FavouriteCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var playerImage: UIImageView!
   
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}


