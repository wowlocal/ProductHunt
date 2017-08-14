//
//  ShowMoreView.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

enum ShowMoreViewState {
	case showButton, showLoader
}

protocol ShowMoreViewDelegate: class {
	func showMoreView(_ showMoreView: ShowMoreView, button: UIButton)
}

class ShowMoreView: UIView {
	
	weak var delegate: ShowMoreViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	convenience init(frame: CGRect, with state: ShowMoreViewState) {
		self.init(frame: frame)
		toggle(to: state)
	}
	
	func toggle(to state: ShowMoreViewState) {
		switch state {
		case .showButton:
			loader.stopAnimating()
			showMoreButton.isHidden = false
		case .showLoader:
			loader.startAnimating()
			showMoreButton.isHidden = true
		}
	}
	
	let loader: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		indicator.color = .black
		indicator.hidesWhenStopped = true
		return indicator
	}()
	let showMoreButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Show More", for: UIControlState())
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.addTarget(self, action: #selector(handleActionButton(_:)), for: .touchUpInside)
		return button
	}()
	let borderLine: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
		return view
	}()
	
}

//MARK: - Making constraints for UI elements
extension ShowMoreView {
	func setupViews() {
		
		addSubview(loader)
		addSubview(showMoreButton)
		addSubview(borderLine)
		self.backgroundColor = .white
		
		loader.snp.makeConstraints { (make) in
			make.center.equalTo(self)
		}
		borderLine.snp.makeConstraints { (make) in
			make.bottom.equalTo(self)
			make.left.right.equalTo(self)
			make.size.equalTo(CGSize(width: frame.width, height: 1))
		}
		showMoreButton.snp.makeConstraints { (make) in
			make.edges.equalTo(self)
			make.size.equalTo(CGSize(width: frame.width, height: frame.height))
		}
		
	}
	func handleActionButton(_ button: UIButton) {
		delegate?.showMoreView(self, button: button)
	}
}
