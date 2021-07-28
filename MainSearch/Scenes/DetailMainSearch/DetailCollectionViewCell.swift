//
//  DetailCollectionViewCell.swift
//  AppSearch
//
//  Created by Minju Ki on 3/25/21.
//

import UIKit

class StatusCell: UICollectionViewCell {
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var middleLabel: UILabel!
	@IBOutlet weak var lastLaebl: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	/// configure Cell by Content
	func configureCell(by content: InfoCollectionData?) {
		topLabel.text = content?.top
		middleLabel.text = content?.middle
		lastLaebl.text = content?.bottom
	}
}

class PreCollectionCell: UICollectionViewCell {
	@IBOutlet weak var preImageView: UIImageView!
	override func awakeFromNib() {
		super.awakeFromNib()
		preImageView.image = UIImage.init(named: "map")
	}
}

class RateCollectionCell: UICollectionViewCell {
	@IBOutlet weak var rateTextView: UITextView!
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
