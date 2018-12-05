//
//  RESTApiIntegrationPresenter.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 03/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

/// The protocol that the view controller handled by presenter must conforms to.
protocol RESTApiIntegrationView: WKPresentableView {
    func showLoading(_ loading: Bool)
}

/// The presenter that will handle all logic of the view.
class RESTApiIntegrationPresenter: WKGenericViewControllerPresenter {
    
    private let userService = UserService()
    
    typealias View = RESTApiIntegrationView
    
    // The view associated to this presenter.
    weak var view: RESTApiIntegrationView?

    required init() {}
    
    func loginDidTap() {
        view?.showLoading(true)
        userService.login(email: "", password: "") { [weak self] result in
            switch result {
            case .success:
                WKLog.debug("success")
            case .failure(let e):
                WKLog.debug(e)
            }
            self?.view?.showLoading(false)
        }
    }
}