//
//  ArticleViewController.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {
    
    var presenter: ArticlesListPresenterInterface?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.notifyViewWillAppear()
    }
}

extension ArticlesViewController: ArticlesListViewInterface {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setInitialTitle(with title: String) {
        self.navigationItem.title = title
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articlesViewModel = presenter?.getArticlesViewModel() else {
            return 0
        }
        return articlesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleCell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.ArticleCell) as? ArticleCell, let article = presenter?.getArticlesViewModel()?[indexPath.row] else {
            return UITableViewCell()
        }
        
        articleCell.title.text = article.name
        
        return articleCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.articlesSelected(navigationController: self.navigationController!, forIndexPath: indexPath, segment: 0)
    }
}


class ArticleCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
}
