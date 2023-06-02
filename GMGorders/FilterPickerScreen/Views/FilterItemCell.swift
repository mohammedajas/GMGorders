//
//  FilterItemCell.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/2/23.
//

import UIKit

class FilterItemCell: UITableViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    
    @IBOutlet weak var selectedStatusImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
