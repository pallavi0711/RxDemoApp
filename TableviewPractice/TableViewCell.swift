//
//  TableViewCell.swift
//  TableviewPractice
//
//  Created by administrator on 29/03/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
