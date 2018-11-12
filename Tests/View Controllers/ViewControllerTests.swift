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
    let bundle = Bundle(for: ViewControllerAndPresenterTests.self)
    
    override func setUp() {
        vc = TestViewController.instantiate(bundle: bundle)
        vc.loadViewIfNeeded()
    }
    
    func testPresenterNotNil() {
        XCTAssertNotNil(vc.presenter)
    }
    
    func testViewDidLoad() {
        vc.viewDidLoad()
        XCTAssert(vc.presenter.isViewDidLoadCalled)
    }

}
