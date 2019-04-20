//
//  TableViewExamplePresenter.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 10/09/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

/// The protocol that the view controller handled by presenter must conforms to.
protocol TableViewExampleView: WKPresentableView {
    func show(names: [String])
    func addMoreNames(names: [String])
}

/// The presenter that will handle all logic of the view.
class TableViewExamplePresenter: WKGenericViewControllerPresenter {
    
    typealias View = TableViewExampleView
    
    var i = 1
    // The view associated to this presenter.
    weak var view: TableViewExampleView?

    required init(with object: Void) {}

    func viewDidLoad() {
        view?.show(names: (i...(i + 99)).map{ "\($0)"})
        i += 100
    }
    
    func addMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.view?.addMoreNames(names: (self.i...(self.i + 99)).map { "\($0)" })
            self.i += 100
        }
    }
}
