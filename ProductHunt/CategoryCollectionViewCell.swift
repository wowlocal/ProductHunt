//
//  CategoryCollectionViewCell.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
	
	var backgroundColorCategory: UIColor = UIColor(hexString: "#da552f")! {
		didSet {
			backgroundCategoryView.backgroundColor = backgroundColorCategory
		}
	}
	let backgroundCategoryView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 15
		view.layer.masksToBounds = true
		return view
	}()
	let categoryLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 18)
		label.textColor = .white
		label.numberOfLines = 1
		label.preferredMaxLayoutWidth = 10
		return label
	}()
	override var isHighlighted: Bool {
		didSet {
			backgroundCategoryView.backgroundColor = isHighlighted ? UIColor.rgb(r: 186, g: 4, b: 21) : backgroundColorCategory
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
		addSubview(backgroundCategoryView)
		addSubview(categoryLabel)
		backgroundCategoryView.backgroundColor = backgroundColorCategory
		categoryLabel.snp.makeConstraints { (make) in
			make.top.equalTo(5)
			make.bottom.equalTo(-5)
			make.right.equalTo(-10)
			make.left.equalTo(10)
		}
		backgroundCategoryView.snp.makeConstraints { (make) in
			make.edges.equalTo(self)
		}
	}
	
}
