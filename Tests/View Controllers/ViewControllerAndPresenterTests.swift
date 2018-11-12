//
//  ViewControllerTests.swift
//  Tests
//
//  Created by Rico Crescenzio on 09/11/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import XCTest

class ViewControllerAndPresenterTests: XCTestCase {
    
    var vc: TestViewController!
    
    override func setUp() {
        vc = TestViewController.instantiate(bundle: Bundle(for: type(of: self)))
        vc.loadViewIfNeeded()
    }
    
    func testPresenterNotNil() {
        XCTAssertNotNil(vc.presenter)
    }
    
    func testViewDidLoad() {
        // view did load is automatically called after `loadViewIfNeeded`, so no need to call viewDidLoad manually
        XCTAssert(vc.presenter.isViewDidLoadCalled)
    }
    
    func testViewWillAppear() {
        XCTAssert(!vc.presenter.isViewWillAppearCalled)
        vc.viewWillAppear(true)
        XCTAssert(vc.presenter.isViewWillAppearCalled)
    }
    
    func testViewDidAppear() {
        XCTAssert(!vc.presenter.isViewDidAppearCalled)
        vc.viewDidAppear(true)
        XCTAssert(vc.presenter.isViewDidAppearCalled)
    }
    
    func testViewWillDisappear() {
        XCTAssert(!vc.presenter.isViewWillDisappearCalled)
        vc.viewWillDisappear(true)
        XCTAssert(vc.presenter.isViewWillDisappearCalled)
    }
    
    func testViewDidDisappear() {
        XCTAssert(!vc.presenter.isViewDidDisappearCalled)
        vc.viewDidDisappear(true)
        XCTAssert(vc.presenter.isViewDidDisappearCalled)
    }


}
