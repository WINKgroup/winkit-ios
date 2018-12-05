//
//  TableViewExampleViewController.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 10/09/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class TableViewExampleViewController: WKViewController<TableViewExamplePresenter> {
    
    @IBOutlet private var tableView: UITableView!
    
    var dataSource: NameTableViewDataSource!
    
    override class var storyboardName: String? {
        return Storyboard.main.name
    }
    
    override func viewDidLoad() {
        dataSource = NameTableViewDataSource(tableView: tableView) {
            self.presenter.addMore()
        }
        super.viewDidLoad()
    }
    
}

extension TableViewExampleViewController: TableViewExampleView {
    
    func show(names: [String]) {
        dataSource.replaceAll(names)
    }
    
    func addMoreNames(names: [String]) {
        dataSource.appendNewContents(from: names, isLastPage: false)
    }
}
