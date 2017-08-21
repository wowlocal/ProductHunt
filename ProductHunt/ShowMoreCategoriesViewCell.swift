//
//  ShowMoreCategoriesViewCell.swift
//  ProductHunt
//
//  Created by misha on 13/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

//
//  TableViewCell.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit
import SnapKit

class ShowMoreCategoriesViewCell: UICollectionViewCell {
	
	let categoryLabel: UILabel = {
		let label = UILabel()
		label.text = "More"
		label.font = UIFont.systemFont(ofSize: 18)
		label.textColor = UIColor.rgb(r: 64, g: 84, b: 254)
		label.numberOfLines = 1
		label.preferredMaxLayoutWidth = 10
		return label
	}()
	override var isHighlighted: Bool {
		willSet {
			categoryLabel.textColor = newValue ? UIColor.rgb(r: 64, g: 84, b: 254, a: 0.3) : UIColor.rgb(r: 64, g: 84, b: 254)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setupViews() {
		addSubview(categoryLabel)
		categoryLabel.snp.makeConstraints { (make) in
			make.top.equalTo(5)
			make.bottom.equalTo(-5)
			make.right.equalTo(-10)
			make.left.equalTo(10)
		}
	}
	
}
