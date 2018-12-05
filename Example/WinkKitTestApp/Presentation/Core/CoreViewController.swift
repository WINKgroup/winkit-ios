//
//  CoreViewController.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 27/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import WinkKit

/// Example of he core view controller of the project. It is a good practise to define some core components for a project.
class CoreViewController<P>: WKViewController<P> where P: WKGenericViewControllerPresenter {
    
    override class var storyboardName: String {
        return "Main"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("called view did load in \(self)")
    }
    
    func showErrorMessage(of error: Error) {
        print("show error \(error.localizedDescription)")
    }
    
    deinit {
        print("destrying \(self)")
    }
}
