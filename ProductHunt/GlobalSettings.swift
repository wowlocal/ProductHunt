//
//  GlobalSettings.swift
//  ProductHunt
//
//  Created by misha on 21/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

struct Networker {
	
	static let baseURL = "https://api.producthunt.com/"
	static let accessToken: String = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
	
}

struct Appearance {
	
	static let PrimaryColor = UIColor(hexString: "#da552f")!
	static let BackgroundColor = UIColor.rgb(r: 246, g: 246, b: 246)
	
	static let TitleTextColor = UIColor.rgb(r: 34, g: 34, b: 34)
	static let BodyTextColor = UIColor.rgb(r: 102, g: 102, b: 102)
	
}
