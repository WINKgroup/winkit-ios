//
//  TestCollectionViewController.swift
//  Tests
//
//  Created by Rico Crescenzio on 20/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import WinkKit

class TestCollectionViewController: WKCollectionViewController<TestPresenter> {
    
    override class var storyboardName: String? {
        return "Test"
    }
    
}

extension TestCollectionViewController: TestView {
    
}
