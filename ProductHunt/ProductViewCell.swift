//
//  TableViewCell.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit
import SnapKit

class ProductViewCell: UITableViewCell {
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18)
		label.numberOfLines = 2
		label.textColor = Appearance.TitleTextColor
		return label
	}()
	let taglineLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 12)
		label.textColor = Appearance.BodyTextColor
		label.numberOfLines = 1
		return label
	}()
	let thumbnailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 5
		imageView.backgroundColor = Appearance.BackgroundColor
		return imageView
	}()
	let upvotesCount: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
		return button
	}()
	let indicatorView: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()
		view.color = .gray
		view.hidesWhenStopped = true
		return view
	}()
	private var valueObservation: NSKeyValueObservation!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		thumbnailImageView.removeObserver(valueObservation, forKeyPath: #keyPath(UIImageView.image))
	}

	//MARK: - Making constraints for UI elements
	func setupViews() {
		addSubview(thumbnailImageView)
		addSubview(nameLabel)
		addSubview(taglineLabel)
		addSubview(upvotesCount)
		addSubview(indicatorView)
		
		indicatorView.startAnimating()

		valueObservation = thumbnailImageView.observe(\.image, options: [.new]) { [unowned self] (image, change) in
			if change.newValue is UIImage {
				self.indicatorView.stopAnimating()
			}
		}
		
		thumbnailImageView.snp.makeConstraints { (make) in
			make.left.equalTo(15)
			make.centerY.equalTo(self)
			make.size.equalTo(CGSize(width: 90, height: 90))
			make.top.equalTo(5)
			make.bottom.equalTo(-5)
		}
		indicatorView.snp.makeConstraints { (make) in
			make.center.equalTo(thumbnailImageView.snp.center)
		}
		nameLabel.snp.makeConstraints { (make) in
			make.top.equalTo(5)
			make.left.equalTo(thumbnailImageView.snp.right).offset(8)
			make.right.equalTo(-8)
		}
		taglineLabel.snp.makeConstraints { (make) in
			make.top.equalTo(nameLabel.snp.bottom).offset(5)
			make.left.equalTo(nameLabel)
			make.right.equalTo(-8)
		}
		upvotesCount.snp.makeConstraints { (make) in
			make.top.equalTo(taglineLabel.snp.bottom).offset(5)
			make.bottom.equalTo(-5)
			make.right.equalTo(-16)
		}
	}
	
}
