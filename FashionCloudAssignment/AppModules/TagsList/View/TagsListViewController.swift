//
//  TagsListViewController.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

class TagsListViewController: UIViewController {
    
    var presenter: TagsListPresenterInterface?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagsSegments: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedIndex = presenter?.selectedIndex else {
            return
        }
        presenter?.notifyTagsViewLoaded(for: selectedIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.notifyViewWillAppear()
    }
    
    @IBAction func tagsSelected(_ sender: UISegmentedControl) {
        switch tagsSegments.selectedSegmentIndex {
        case 0:
            presenter?.notifySegmentChanged(index: 0)
        case 1:
            presenter?.notifySegmentChanged(index: 1)
        case 2:
            presenter?.notifySegmentChanged(index: 2)
        default:
            break
        }
    }
}

extension TagsListViewController: TagsListViewInterface {
    
    func setSegmentControl() {
        guard let mappingSets = presenter?.getMappingSets() else { return }
        var i = 0
        for set in mappingSets {
            self.tagsSegments.setTitle(set.name, forSegmentAt: i)
            i += 1
        }
        
    }
    
    func reloadTagsData() {
        self.tableView.reloadData()
    }
    
    func setInitialTitle(with title: String) {
        self.title = title
    }
    
}

extension TagsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tagsViewModel = presenter?.getTagsViewModel() else {
            return 0
        }
        return tagsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tagCell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.TagsListCell) as? TagCell, let tag = presenter?.getTagsViewModel()?[indexPath.row] else {
            return UITableViewCell()
        }
        
        tagCell.tags.text = tag
        
        return tagCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}

class TagCell: UITableViewCell {
    @IBOutlet weak var tags: UILabel!
}

