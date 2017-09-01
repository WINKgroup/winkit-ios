//
//  SpinnerTableViewCell.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 30/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

public class SpinnerTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SpinnerTableViewCell"
    
    var activityIndicatorView: UIActivityIndicatorView!

    override public func setSelected(_ selected: Bool, animated: Bool) {
        // does nothing
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        contentView.addSubview(activityIndicatorView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = contentView.center
    }
    
    func configure(withColor color: UIColor?) {
        activityIndicatorView.color = color
        activityIndicatorView.startAnimating()
    }
    
}
