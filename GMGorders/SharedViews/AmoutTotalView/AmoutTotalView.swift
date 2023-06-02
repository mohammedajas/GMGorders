//
//  ShowingAmoutTotalView.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/2/23.
//

import UIKit

class AmoutTotalView: XibView {
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoTextLabel.text = Constants.totalSum
    }
}
