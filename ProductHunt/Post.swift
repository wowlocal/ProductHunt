//
//  Post.swift
//  ProductHunt
//
//  Created by misha on 11/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import Foundation

struct Post {
	private let _name: String?
	private var _votes: Int?
	private let _thumbnailURL: String?
	private let _screenshotURL: String?
	private let _redirectURL: String?
	private let _tagline: String?
	
	var name: String? {
		return _name
	}
	var votes: Int? {
		return _votes
	}
	var thumbnailURL: String? {
		return _thumbnailURL
	}
	var screenshotURL: String? {
		return _screenshotURL
	}
	var redirectURL: String? {
		return _redirectURL
	}
	var tagline: String? {
		return _tagline
	}
	
	init(dictionary: [String: AnyObject]) {
		self._name = dictionary["name"] as? String
		self._votes = dictionary["votes_count"] as? Int
		self._tagline = dictionary["tagline"] as? String
		self._redirectURL = dictionary["redirect_url"] as? String
		if let dictScreenshot = dictionary["screenshot_url"] as? [String: String] {
			self._screenshotURL = dictScreenshot["300px"]
		} else { self._screenshotURL = nil }
		if let dictThumbnail = dictionary["thumbnail"] as? [String: AnyObject] {
			self._thumbnailURL = dictThumbnail["image_url"] as? String
		} else { self._thumbnailURL = nil }
	}
	
	static func parsePosts(response: Any?) -> [Post]? {
		guard let postsDictionary = response as? NSDictionary,
			let postsArray = postsDictionary["posts"] as? NSArray
		else {
			return nil
		}
		var posts: [Post] = []
		for item in postsArray {
			guard let dict = item as? [String: AnyObject] else { return nil }
			let post = Post(dictionary: dict)
			posts.append(post)
		}
		return posts
	}
	
}
