//
//  TestViewControllerWithInit.swift
//  Tests
//
//  Created by Rico Crescenzio on 09/11/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class TestViewControllerWithInit: WKViewController<TestPresenterWithInit> {
    
    override class var storyboardName: String? {
        return "Test"
    }
    
}

extension TestViewControllerWithInit: TestView {
    
}
