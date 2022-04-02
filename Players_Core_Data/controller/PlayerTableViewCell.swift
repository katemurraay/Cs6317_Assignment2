//
//  PlayerCell.swift
//  ManUnitedApp
//
//  Created by Kate Murray on 15/03/2022.
//

import UIKit

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
      
    }
  
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}



    

