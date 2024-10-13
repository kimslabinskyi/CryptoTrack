//
//  InfoTableViewCell.swift
//  CryptoTrack
//
//  Created by Kim on 02.10.2024.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
