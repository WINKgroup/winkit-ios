//
//  TestPresenterWithInit.swift
//  Tests
//
//  Created by Rico Crescenzio on 09/11/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

struct TestInitObject {
    
}

/// The presenter that will handle all logic of the view.
class TestPresenterWithInit: WKGenericViewControllerPresenter {
    
    // The view associated to this presenter.
    weak var view: TestView?
    private(set) var isViewDidLoadCalled = false,
    isViewWillAppearCalled = false,
    isViewDidAppearCalled = false,
    isViewWillDisappearCalled = false,
    isViewDidDisappearCalled = false,
    isViewDidDestroyCalled = false
    let testInitObject: TestInitObject
    
    required init(with object: TestInitObject) {
        self.testInitObject = object
    }
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    func viewWillAppear() {
        isViewWillAppearCalled = true
    }
    
    func viewDidAppear() {
        isViewDidAppearCalled = true
    }
    
    func viewWillDisappear() {
        isViewWillDisappearCalled = true
    }
    
    func viewDidDisappear() {
        isViewDidDisappearCalled = true
    }
    
    func viewDidDestroy() {
        isViewDidDestroyCalled = true
    }
    
}
