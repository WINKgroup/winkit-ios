//
//  TestTabBarController.swift
//  Tests
//
//  Created by Rico Crescenzio on 20/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import WinkKit

class TestTabBarController: WKTabBarController<TestPresenter> {
    
    override class var storyboardName: String? {
        return "Test"
    }
    
}

extension TestTabBarController: TestView {
    
}
