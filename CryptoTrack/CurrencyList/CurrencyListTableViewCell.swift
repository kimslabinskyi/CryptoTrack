//
//  CurrencyListTableViewCell.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit

class CurrencyListTableViewCell: UITableViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var sideButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
