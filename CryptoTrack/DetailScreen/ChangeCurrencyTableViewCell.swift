//
//  ChangeCurrencyTableViewCell.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit

class ChangeCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var centralLabel: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
