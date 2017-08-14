//
//  Extensions.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit
import Alamofire

extension UIColor {
	static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
		return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
	}
	static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
		return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
	}
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
	
	func loadImageUsingCacheWithUrlString(_ urlString: String) {
		self.image = nil
		
		if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
			self.image = cachedImage
			return
		}
		
		guard let url = URL(string: urlString) else {
			return
		}
		
		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			
			if error != nil {
				print(error ?? "")
				return
			}
			
			DispatchQueue.main.async(execute: { [weak self] in
				
				if let downloadedImage = UIImage(data: data!) {
					imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
					self?.image = downloadedImage
				}
			})
			
		}).resume()
	}
	
}
