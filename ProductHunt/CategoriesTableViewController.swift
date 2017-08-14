//
//  CategoriesTableViewController.swift
//  ProductHunt
//
//  Created by misha on 10/08/2017.
//  Copyright © 2017 misha. All rights reserved.
//

import UIKit

protocol MainScreen: class {
	var currentCategory: Category { get set }
}

private let rowId = "rowId"

class CategoriesTableViewController: UITableViewController {
	
	var categories: [Category] = [] {
		didSet {
			let range = NSMakeRange(0, self.tableView.numberOfSections)
			let sections = NSIndexSet(indexesIn: range)
			tableView.reloadSections(sections as IndexSet, with: .automatic)
		}
	}
	
	weak var mainScreen: MainScreen?

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Categories"
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		
		tableView.tableFooterView = UIView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: rowId)
    }
	
	func handleCancel() {
		dismiss(animated: true, completion: nil)
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rowId, for: indexPath)
		cell.textLabel?.text = categories[indexPath.item].name
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		dismiss(animated: true) { [weak self] in
			guard let category = self?.categories[indexPath.item] else { return }
			self?.mainScreen?.currentCategory = category
		}
	}

}
