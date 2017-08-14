//
//  Post.swift
//  ProductHunt
//
//  Created by misha on 11/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import Foundation

struct Post {
	let name: String?
	var votes: Int?
	let thumbnailURL: String?
	let screenshotURL: String?
	let redirectURL: String?
	let tagline: String?
	
	init(dictionary: [String: AnyObject]) {
		self.name = dictionary["name"] as? String
		self.votes = dictionary["votes_count"] as? Int
		self.tagline = dictionary["tagline"] as? String
		self.redirectURL = dictionary["redirect_url"] as? String
		if let dictScreenshot = dictionary["screenshot_url"] as? [String: String] {
			self.screenshotURL = dictScreenshot["300px"]
		} else { self.screenshotURL = nil }
		if let dictThumbnail = dictionary["thumbnail"] as? [String: AnyObject] {
			self.thumbnailURL = dictThumbnail["image_url"] as? String
		} else { self.thumbnailURL = nil }
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
