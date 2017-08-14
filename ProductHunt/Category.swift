//
//  Category.swift
//  ProductHunt
//
//  Created by misha on 11/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit
import ChameleonFramework

func == (a: Category, b: Category) -> Bool {
	return a.color == b.color && a.slug == b.slug && a.name == b.name
}
func != (a: Category, b: Category) -> Bool {
	return a.color != b.color || a.slug != b.slug || a.name != b.name
}

struct Category {
	let slug: String?
	let name: String?
	let color: UIColor?
	
	init(dictionary: [String: AnyObject]) {
		self.slug = dictionary["slug"] as? String
		self.name = dictionary["name"] as? String
		if let hexColor = dictionary["color"] as? String {
			self.color = UIColor.init(hexString: hexColor)
		} else { self.color = nil }
	}
	init(slug: String, name: String, color: UIColor) {
		self.slug = slug
		self.name = name
		self.color = color
	}
	
	static func parseCategories(response: Any?) -> [Category]? {
		guard let dictionary = response as? NSDictionary,
			let categoriesArray = dictionary.value(forKey: "categories") as? NSArray else { return nil }
		var categories: [Category] = []
		for item in categoriesArray {
			let category = Category(dictionary: item as! [String: AnyObject])
			categories.append(category)
		}
		return categories.count > 0 ? categories : nil
	}
	
}
