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
	private let _slug: String?
	private let _name: String?
	private let _color: UIColor?
	
	var slug: String? {
		return _slug
	}
	var name: String? {
		return _name
	}
	var color: UIColor? {
		return _color
	}
	
	init(dictionary: [String: AnyObject]) {
		self._slug = dictionary["slug"] as? String
		self._name = dictionary["name"] as? String
		if let hexColor = dictionary["color"] as? String {
			self._color = UIColor.init(hexString: hexColor)
		} else { self._color = nil }
	}
	init(slug: String, name: String, color: UIColor) {
		self._slug = slug
		self._name = name
		self._color = color
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
