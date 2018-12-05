//
//  CollectionViewPresenter.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 05/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

/// The protocol that the view controller handled by presenter must conforms to.
protocol CollectionViewView: WKPresentableView {
    func show(names: [String])
    func addMoreNames(names: [String])
}

/// The presenter that will handle all logic of the view.
class CollectionViewPresenter: WKGenericViewControllerPresenter {
    
    typealias View = CollectionViewView
    var i = 1
    
    // The view associated to this presenter.
    weak var view: CollectionViewView?

    required init() {
        // Required empty initializer, put here other init stuff
    }
    
    func viewDidLoad() {
        view?.show(names: (i...(i + 99)).map{ "\($0)"})
        i += 100
    }
    
    func addMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.view?.addMoreNames(names: (self.i...(self.i + 99)).map{ "\($0)"})
            self.i += 100
        }
    }
}
