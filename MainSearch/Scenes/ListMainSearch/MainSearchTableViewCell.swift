//
//  MainSearchTableViewCell.swift
//  AppSearch
//
//  Created by Minju Ki on 3/23/21.
//

import UIKit

class MainSearchTableViewCell: UITableViewCell {

	@IBOutlet weak var appImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var openBtn: UIButton!
	@IBOutlet weak var stackView: UIStackView!

	override func awakeFromNib() {
		super.awakeFromNib()
		initUI()
	}

	private func initUI() {
		openBtn.roundCorners(.allCorners, radius: 10)
	}

	/// configure Cell by Content
	func configureCell(by content: InquiryCellValue) {
		titleLabel.text = content.collectionName
		subTitleLabel.text = content.artistName
		appImageView.makePreview(url: content.artworkUrl60)
	}

	override func prepareForReuse() {
		appImageView.image = nil
	}
}
