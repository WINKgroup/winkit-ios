//
//  NamePresenter.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 04/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

/// The protocol that the NameTableViewCell handled by presenter must conforms to.
protocol NameView: WKPresentableView {
    func show(name: String)
}

/// The presenter that will handle all logic of the NameView.
class NamePresenter: WKPresenter {
    
    typealias View = NameView
    
    // The view associated to this presenter.
    weak var view: NameView?

    init(view: NameView, name: String) {
        self.view = view
        view.show(name: name)
    }
}
