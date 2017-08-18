//
//  ProductPageView.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

protocol ProductPageViewDelegate: class {
	func productPageView(_ productPageView: ProductPageView, button: UIButton)
}

class ProductPageView: UIView {
	
	weak var delegate: ProductPageViewDelegate?
	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 22)
		label.textColor = UIColor.rgb(r: 34, g: 34, b: 34)
		label.numberOfLines = 3
		return label
	}()
	let productImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.masksToBounds = true
		imageView.backgroundColor = UIColor.rgb(r: 246, g: 246, b: 246)
		return imageView
	}()
	let taglineLabel: UILabel = {
		let field = UILabel()
		field.font = UIFont.systemFont(ofSize: 17)
		field.numberOfLines = 9999999
		field.textColor = UIColor.rgb(r: 102, g: 102, b: 102)
		return field
	}()
	let getItButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("GET IT", for: UIControlState())
		button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
		return button
	}()
	
	convenience init() {
		self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func handleActionButton(_ button: UIButton) {
		delegate?.productPageView(self, button: button)
	}
	
	func setupViews() {
		let scrollView = UIScrollView()
		addSubview(scrollView)
		scrollView.snp.makeConstraints { (make) in
			make.edges.equalTo(self)
		}
		let containerView = UIView()
		scrollView.addSubview(containerView)
		containerView.snp.makeConstraints { (make) in
			make.edges.equalTo(scrollView)
			make.width.equalTo(self)
		}
		containerView.addSubview(nameLabel)
		containerView.addSubview(productImageView)
		containerView.addSubview(taglineLabel)
		containerView.addSubview(getItButton)
		nameLabel.snp.makeConstraints { (make) in
			make.left.equalTo(20)
			make.top.equalTo(12)
			make.right.equalTo(-20)
		}
		productImageView.snp.makeConstraints { (make) in
			make.top.equalTo(nameLabel.snp.bottom).offset(28)
			make.left.equalTo(self)
			make.right.equalTo(self)
			make.size.height.equalTo(self.frame.width / 16 * 9)
			make.size.width.equalTo(self.frame.width)
		}
		taglineLabel.snp.makeConstraints { (make) in
			make.top.equalTo(productImageView.snp.bottom).offset(12)
			make.left.equalTo(20)
			make.right.equalTo(-20)
		}
		getItButton.snp.makeConstraints { (make) in
			make.top.equalTo(taglineLabel.snp.bottom).offset(12)
			make.left.equalTo(40)
			make.right.equalTo(-40)
			make.bottom.equalTo(-22)
		}
	}
	
}

