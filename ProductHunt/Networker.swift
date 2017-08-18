//
//  File.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

final class Networker {
	
	let baseURL = "https://api.producthunt.com/"
	var accessToken: String = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
	
	static let sharedInstance = Networker()
	private init() {}
	
}
