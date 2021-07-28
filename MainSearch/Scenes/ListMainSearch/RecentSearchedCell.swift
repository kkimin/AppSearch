//
//  RecentSearchedCell.swift
//  AppSearch
//
//  Created by Minju Ki on 3/23/21.
//

import UIKit

class RecentSearchedCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	func configureCell(by content: String) {
		titleLabel.text = content
	}
}
