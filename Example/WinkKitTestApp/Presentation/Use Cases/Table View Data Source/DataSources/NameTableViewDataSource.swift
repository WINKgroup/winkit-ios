//
//  NameTableViewDataSource.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 04/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class NameTableViewDataSource: WKTableViewInfiniteDataSourceDelegate<String> {
    
    let paginationHandler: () -> Void
    
    init(tableView: UITableView, paginationHandler: @escaping () -> Void) {
        self.paginationHandler = paginationHandler
        super.init(tableView: tableView)
        tableView.register(cell: NameTableViewCell.self)
    }
    
    override func tableView(_ tableView: UITableView, normalCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: NameTableViewCell.self, for: indexPath)
        
        let presenter = NamePresenter(view: cell, name: items[indexPath.row])
        cell.configure(with: presenter)
        
        return cell
    }
    
    override func loadingViewForTableView(_ tableView: UITableView) -> WKLoadableUIView {
        return WKSpinnerView()
    }
    
    override func tableView(_ tableView: UITableView, readyForNextPageInSection section: Int) {
        paginationHandler()
    }
}

public class CustomSpinnerView: WKLoadableUIView {
    
    let label = UILabel()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    func setup() {
        backgroundColor = .lightGray
        addSubview(activityIndicatorView)
        addSubview(label)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Custom footer!!!"
        
        activityIndicatorView.color = .red
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
    public func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    public func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    

}
