//
//  ProductPageViewController.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

class ProductPageViewController: UIViewController {
	
	let productPageView = ProductPageView()
	var post: Post? {
		didSet {
			if let name = post?.name {
				productPageView.nameLabel.text = name
			}
			if let tagline = post?.tagline {
				productPageView.taglineLabel.text = tagline
			}
			if let screenshotURL = post?.screenshotURL {
				productPageView.productImageView.loadImageUsingCacheWithUrlString(screenshotURL)
			}
		}
	}
	
	override func loadView() {
		super.loadView()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
		                                                    target: self, action: #selector(shareButtonAction))
		
	}
	
	func shareButtonAction() {
		let activityVC = UIActivityViewController(activityItems: [post?.name ?? "", post?.redirectURL ?? ""], applicationActivities: nil)
		activityVC.popoverPresentationController?.sourceView = self.view
		self.present(activityVC, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		productPageView.delegate = self
		view.addSubview(productPageView)
	}
	
}

//MARK: - ProductPageViewDelegate
extension ProductPageViewController: ProductPageViewDelegate {
	
	func productPageView(_ productPageView: ProductPageView, button: UIButton) {
		guard let redirectURL = post?.redirectURL,
			let url = URL(string: redirectURL) else { return }
		if #available(iOS 10.0, *) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			UIApplication.shared.openURL(url)
		}
	}
	
}


