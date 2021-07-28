//
//  CommonExtentions.swift
//  AppSearch
//
//  Created by Minju Ki on 3/25/21.
//
// Extensions 파일

import UIKit

// MARK: - UIView Extension

extension UIView {
	/**
	UIView Round 처리
	- Parameter corners: UIRectCorner : [.topRight, .topLeft, .bottomLeft, .bottomRight]
	- Parameter radius: radius 값
	- Returns: rounding 처리 된 UIView
	*/
	func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		var cornerMask = CACornerMask()
		if(corners.contains(.topLeft)) {
			cornerMask.insert(.layerMinXMinYCorner)
		}
		if(corners.contains(.topRight)) {
			cornerMask.insert(.layerMaxXMinYCorner)
		}
		if(corners.contains(.bottomLeft)) {
			cornerMask.insert(.layerMinXMaxYCorner)
		}
		if(corners.contains(.bottomRight)) {
			cornerMask.insert(.layerMaxXMaxYCorner)
		}
		self.layer.cornerRadius = radius
		self.layer.maskedCorners = cornerMask
	}
}

// MARK: - UIImageView Extension

extension UIImageView { // 수정
	// makePreview 생성
	func makePreview(url: String) {
		DispatchQueue.global(qos: .default).async { [weak self] in
			if let url: URL = URL.init(string: url) { // URL 셋팅
				if let data = try? Data.init(contentsOf: url, options: []) { // data 셋팅
					if let image = UIImage.init(data: data) {
						DispatchQueue.main.async {
							self?.image = image
						}
					}
				}
			}
		}
	}
}

// MARK: - Data Extension

extension Data {
	/// JSON Data를 예쁘게 String으로 변환
	var prettyPrintedJSONString: String {
		guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
			  let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
			  let prettyPrintedString = String(data: data, encoding: .utf8) else { return "" }
		return prettyPrintedString
	}
}

// MARK: - UILabel Extension

extension UILabel {
	/**
	Label letter Spacing 생성
	- Parameter kernValue: letter spacing 적용할 값
	- Returns: letter spacing 적용한 UILabel
	*/
	func setLetterSpacing(kernValue: Double) {
		if let labelText = text, labelText.count > 0 {
			let attributedString = NSMutableAttributedString(string: labelText)
			attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
			attributedText = attributedString
		}
	}
}

extension UIStackView {
	/// add Horizontal StackView with Key and Value as UILabel
	func makeStackView(data: [String: String]) {
		let order = data.sorted(by: <)

		for (key, value) in order {
			let stackView = UIStackView.init()
			stackView.axis = .horizontal
			stackView.spacing = 0
			stackView.distribution = .fillProportionally
			let leftlabel = UILabel.init()
			leftlabel.text = key
			let rightLabel = UILabel.init()
			rightLabel.text = value
			stackView.addArrangedSubview(leftlabel)
			stackView.addArrangedSubview(rightLabel)
			stackView.alignment = .top
			rightLabel.textAlignment = .right
			self.addArrangedSubview(stackView)
		}
	}
}
