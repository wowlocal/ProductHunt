//
//  Extensions.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit
import Alamofire

private let factor = 0.7

extension UIColor {
	
	var coreImageColor: CIColor {
		return CIColor(color: self)
	}
	
	var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		let coreImageColor = self.coreImageColor
		return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
	}
	
	static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
		return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
	}
	
	/**
	 * Creates a new Color that is a brighter version of this Color
	 */
	func brighter() -> UIColor {
		var r = self.components.red * 255
		var g = self.components.green * 255
		var b = self.components.blue * 255
		
		let i = CGFloat(1 / (1 - factor))
		if r == 0 && g == 0 && b == 0 {
			return UIColor.rgb(r: i, g: i, b: i)
		}
		if r > 0 && r < i { r = i }
		if g > 0 && g < i { g = i }
		if b > 0 && b < i { b = i }
		return UIColor.rgb(r: min(CGFloat(Double(r) / factor), 255),
		                   g: min(CGFloat(Double(g) / factor), 255),
		                   b: min(CGFloat(Double(b) / factor), 255))
	}
	
	/**
	 * Creates a new Color that is a darker version of this Color
	 */
	func darker() -> UIColor {
		let newRed = CGFloat(Double(self.components.red * 255) * factor)
		let newGreen = CGFloat(Double(self.components.green * 255) * factor)
		let newBlue = CGFloat(Double(self.components.blue * 255) * factor)
		
		return UIColor.rgb(r: max(newRed, 0),
		                   g: max(newGreen, 0),
		                   b: max(newBlue, 0))
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
