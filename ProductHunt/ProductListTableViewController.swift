//
//  ViewController.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift

private let cellId = "cellId"
private let categoriCellId = "categoriCellId"
private let showMoreCategoriesCellId = "showMoreCategoriesCellId"

class ProductListTableViewController: UITableViewController, MainScreen {

	var categories: [Category] = [] {
		didSet {
			//TODO: FIX IT
			categoriesCollectionView.reloadData()
			categoriesCollectionView.reloadData()
		}
	}
	var posts: [Post] = [] {
		didSet {
			reloadTableView()
			tableView.isScrollEnabled = true
			tableView.tableFooterView = showMoreView
			activityIndicator.stopAnimating()
			self.refresher.endRefreshing()
		}
	}
	var currentCategory: Category = Category(slug: "tech", name: "Tech", color: UIColor(hexString: "#da552f")!) {
		didSet {
			downloadPosts()
			categoriesCollectionView.reloadData()
		}
	}
	
	let token = Networker.sharedInstance.accessToken
	let baseURL = Networker.sharedInstance.baseURL
	let refresher = UIRefreshControl()
	private let screenWidth = UIScreen.main.bounds.width
	var numberOfShownCategories = 3 {
		didSet {
			categoriesCollectionView.reloadData()
		}
	}
	var whowExtraCategories: Bool {
		return categories.count > numberOfShownCategories
	}
	var numberOfShownPosts = 5
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.center = self.view.center
		indicator.hidesWhenStopped = true
		indicator.color = UIColor(hexString: "#da552f")
		return indicator
	}()
	lazy var showMoreView: ShowMoreView = {
		let view = ShowMoreView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: 40))
		view.delegate = self
		view.toggle(to: .showButton)
		return view
	}()
	lazy var categoriesCollectionView: UICollectionView = {
		let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: 50), collectionViewLayout: UICollectionViewFlowLayout())
		view.backgroundColor = .clear
		view.isPagingEnabled = true
		view.showsHorizontalScrollIndicator = false
		if let layout = view.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
			layout.estimatedItemSize = CGSize(width: 1, height: 1)
		}
		view.delegate = self
		view.dataSource = self
		view.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: categoriCellId)
		view.register(ShowMoreCategoriesViewCell.self, forCellWithReuseIdentifier: showMoreCategoriesCellId)
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView!.backgroundColor = UIColor.rgb(r: 249, g: 249, b: 249)
		view.addSubview(activityIndicator)
		tableView!.register(ProductViewCell.self, forCellReuseIdentifier: cellId)
		
		tableView.tableFooterView = UIView()
		tableView.tableHeaderView = categoriesCollectionView
		
		tableView.estimatedRowHeight = 300
		tableView.rowHeight = UITableViewAutomaticDimension
		
		refresher.attributedTitle = NSAttributedString(attributedString: NSAttributedString(string: "refresh...", attributes: [NSForegroundColorAttributeName: UIColor.black]))
		tableView.refreshControl = refresher
		tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		
		fetchCategories()
		downloadPosts()
	}
	
	func reloadTableView() {
		let range = NSMakeRange(0, self.tableView.numberOfSections)
		let sections = NSIndexSet(indexesIn: range)
		tableView.reloadSections(sections as IndexSet, with: .automatic)
	}
	
	func handleRefresh() {
		guard let slug = currentCategory.slug else { return }
		fetchPosts(forGiven: slug)
	}
	
	func downloadPosts() {
		if posts.count > 0 {
			posts.removeAll()
		}
		self.navigationItem.title = currentCategory.name
		guard let slug = currentCategory.slug else { return }
		fetchPosts(forGiven: slug)
		tableView.isScrollEnabled = false
		tableView.tableFooterView = UIView()
		activityIndicator.startAnimating()
	}
	
	func fetchPosts(forGiven categorySlug: String = "tech") {
		let parameters: Parameters = ["access_token": token]
		Alamofire.request("\(baseURL)v1/categories/\(categorySlug)/posts", parameters: parameters).responseJSON { [weak self] (response) in
			switch response.result {
			case .success:
				guard let posts = Post.parsePosts(response: response.value) else {
					self?.view.makeToast("invalid JSON", duration: 3, position: .center)
					break
				}
				self?.posts = posts
			case .failure(let error):
				self?.view.makeToast(error.localizedDescription, duration: 3, position: .center)
			}
		}
	}
	func fetchCategories() {
		let parameters: Parameters = ["access_token": token]
		Alamofire.request("\(baseURL)v1/categories", parameters: parameters).responseJSON { [weak self] (response) in
			switch response.result {
			case .success:
				guard let categories = Category.parseCategories(response: response.value) else {
					self?.view.makeToast("invalid JSON", duration: 3, position: .center)
					break
				}
				self?.categories = categories
			case .failure(let error):
				self?.view.makeToast(error.localizedDescription, duration: 3, position: .center)
			}
		}
	}

}

// MARK: - UITableViewDelegate/UITableViewDataSource implementation
extension ProductListTableViewController {
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductViewCell
		
		let post = posts[indexPath.item]
		if let name = post.name {
			cell.nameLabel.text = name
		}
		if let tagline = post.tagline {
			cell.taglineLabel.text = tagline
		}
		if let votes = post.votes {
			cell.upvotesCount.setTitle(String(votes), for: UIControlState())
		}
		if let thumbnailURL = post.thumbnailURL {
			cell.thumbnailImageView.loadImageUsingCacheWithUrlString(thumbnailURL)
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let productPageViewController = ProductPageViewController()
		productPageViewController.post = posts[indexPath.item]
		navigationController?.pushViewController(productPageViewController, animated: true)
	}

}

// MARK: - ShowMoreViewDelegate
extension ProductListTableViewController: ShowMoreViewDelegate {
	func showMoreView(_ showMoreView: ShowMoreView, button: UIButton) {
		showMoreView.toggle(to: .showLoader)
	}
}

// MARK: - UICollectionViewDelegate
extension ProductListTableViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if whowExtraCategories && indexPath.item == numberOfShownCategories {
			let categoriesTableViewController = CategoriesTableViewController()
			categoriesTableViewController.categories = categories
			categoriesTableViewController.mainScreen = self
			let navigationController = UINavigationController(rootViewController: categoriesTableViewController)
			present(navigationController, animated: true, completion: nil)
		} else if currentCategory != categories[indexPath.item] {
			currentCategory = categories[indexPath.item]
		}
	}
	
}

//MARK: - UICollectionViewDataSource
extension ProductListTableViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if whowExtraCategories {
			return numberOfShownCategories + 1
		}
		return categories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if whowExtraCategories, indexPath.item == numberOfShownCategories {
			let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: showMoreCategoriesCellId, for: indexPath)
			return cell
		}
		let category = categories[indexPath.item]
		let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: categoriCellId, for: indexPath) as! CategoryCollectionViewCell
		cell.categoryLabel.text = category.name
		
		if let color = category.color {
			cell.backgroundColorCategory = category == currentCategory ? UIColor.red : color
		} else {
			cell.backgroundColorCategory = category == currentCategory ? UIColor.red : UIColor(hexString: "#da552f")!
		}
		
		return cell
	}
	
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProductListTableViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(0, 15, 0, 15)
	}
	
}
