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
    var vc2: TestViewControllerWithInit!
    var tableVC: TestTableViewController!
    var colVC: TestCollectionViewController!
    var tabBarC: TestTabBarController!
    
    override func setUp() {
        guard vc == nil else { return }
        vc = TestViewController.instantiate(bundle: Bundle(for: type(of: self)))
        vc.loadViewIfNeeded()
        
        guard tableVC == nil else { return }
        tableVC = TestTableViewController.instantiate(bundle: Bundle(for: type(of: self)))
        tableVC.loadViewIfNeeded()
        
        guard colVC == nil else { return }
        colVC = TestCollectionViewController.instantiate(bundle: Bundle(for: type(of: self)))
        colVC.loadViewIfNeeded()
        
        guard tabBarC == nil else { return }
        tabBarC = TestTabBarController.instantiate(bundle: Bundle(for: type(of: self)))
        tabBarC.loadViewIfNeeded()
    }
    
    func testInitWithObject() {
        vc2 = TestViewControllerWithInit.instantiate(initObject: TestInitObject(), bundle: Bundle(for: type(of: self)))
    }
    
    func testPresenterNotNil() {
        XCTAssertNotNil(vc.presenter)
        XCTAssertNotNil(tableVC.presenter)
        XCTAssertNotNil(colVC.presenter)
        XCTAssertNotNil(tabBarC.presenter)
    }
    
    func testViewDidLoad() {
        XCTAssert(vc.presenter.isViewDidLoadCalled)
        XCTAssert(tableVC.presenter.isViewDidLoadCalled)
        XCTAssert(colVC.presenter.isViewDidLoadCalled)
        XCTAssert(tabBarC.presenter.isViewDidLoadCalled)
    }
    
    func testViewWillAppear() {
        XCTAssert(!vc.presenter.isViewWillAppearCalled)
        vc.viewWillAppear(true)
        XCTAssert(vc.presenter.isViewWillAppearCalled)
        
        XCTAssert(!tableVC.presenter.isViewWillAppearCalled)
        tableVC.viewWillAppear(true)
        XCTAssert(tableVC.presenter.isViewWillAppearCalled)
        
        XCTAssert(!colVC.presenter.isViewWillAppearCalled)
        colVC.viewWillAppear(true)
        XCTAssert(colVC.presenter.isViewWillAppearCalled)
        
        XCTAssert(!tabBarC.presenter.isViewWillAppearCalled)
        tabBarC.viewWillAppear(true)
        XCTAssert(tabBarC.presenter.isViewWillAppearCalled)
    }
    
    func testViewDidAppear() {
        XCTAssert(!vc.presenter.isViewDidAppearCalled)
        vc.viewDidAppear(true)
        XCTAssert(vc.presenter.isViewDidAppearCalled)
        
        XCTAssert(!tableVC.presenter.isViewDidAppearCalled)
        tableVC.viewDidAppear(true)
        XCTAssert(tableVC.presenter.isViewDidAppearCalled)
        
        XCTAssert(!colVC.presenter.isViewDidAppearCalled)
        colVC.viewDidAppear(true)
        XCTAssert(colVC.presenter.isViewDidAppearCalled)
        
        XCTAssert(!tabBarC.presenter.isViewDidAppearCalled)
        tabBarC.viewDidAppear(true)
        XCTAssert(tabBarC.presenter.isViewDidAppearCalled)
    }
    
    func testViewWillDisappear() {
        XCTAssert(!vc.presenter.isViewWillDisappearCalled)
        vc.viewWillDisappear(true)
        XCTAssert(vc.presenter.isViewWillDisappearCalled)
        
        XCTAssert(!tableVC.presenter.isViewWillDisappearCalled)
        tableVC.viewWillDisappear(true)
        XCTAssert(tableVC.presenter.isViewWillDisappearCalled)
        
        XCTAssert(!colVC.presenter.isViewWillDisappearCalled)
        colVC.viewWillDisappear(true)
        XCTAssert(colVC.presenter.isViewWillDisappearCalled)
        
        XCTAssert(!tabBarC.presenter.isViewWillDisappearCalled)
        tabBarC.viewWillDisappear(true)
        XCTAssert(tabBarC.presenter.isViewWillDisappearCalled)
    }
    
    func testViewDidDisappear() {
        XCTAssert(!vc.presenter.isViewDidDisappearCalled)
        vc.viewDidDisappear(true)
        XCTAssert(vc.presenter.isViewDidDisappearCalled)
        
        XCTAssert(!tableVC.presenter.isViewDidDisappearCalled)
        tableVC.viewDidDisappear(true)
        XCTAssert(tableVC.presenter.isViewDidDisappearCalled)
        
        XCTAssert(!colVC.presenter.isViewDidDisappearCalled)
        colVC.viewDidDisappear(true)
        XCTAssert(colVC.presenter.isViewDidDisappearCalled)
        
        XCTAssert(!tabBarC.presenter.isViewDidDisappearCalled)
        tabBarC.viewDidDisappear(true)
        XCTAssert(tabBarC.presenter.isViewDidDisappearCalled)
    }

}
