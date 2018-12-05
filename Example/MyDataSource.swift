//
//  MyDataSource.swift
//  
//
//  Created by Rico Crescenzio on 06/07/2018.
//

import WinkKit

class MyDataSource: WKTableViewDataSource<MyCell> {
    
    override init(tableView: UITableView) {
        super.init(tableView: tableView)
        tableView.register(cell: MyCell.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(ofType: MyCell.self, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MyCell {
            let presenter = <#instantiate here presenter#>
            cell.configure(with: presenter)
        }
    }
}
