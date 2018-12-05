//
//  NamePresenter.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 05/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

/// The protocol that the NameCollectionViewCell handled by presenter must conforms to.
protocol NameForCellView: WKPresentableView {
    func show(name: String)
}

/// The presenter that will handle all logic of the NameView.
class NameForCellPresenter: WKPresenter {
    
    typealias View = NameForCellView
    
    // The view associated to this presenter.
    weak var view: NameForCellView?

    init(view: NameForCellView, name: String) {
        self.view = view
        view.show(name: name)
    }
    
}


