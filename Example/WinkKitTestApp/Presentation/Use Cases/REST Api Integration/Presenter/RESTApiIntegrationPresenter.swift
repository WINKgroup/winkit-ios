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
    func show(user: User)
    func show(error: String)
}

struct RESTApiInit {
    
    let userService = UserService()
    
}

/// The presenter that will handle all logic of the view.
class RESTApiIntegrationPresenter: WKGenericViewControllerPresenter {
    
    private let userService = UserService()
    
    typealias View = RESTApiIntegrationView
    
    // The view associated to this presenter.
    weak var view: RESTApiIntegrationView?

    required init(with object: Void) {}
    
    func loginDidTap() {
        view?.showLoading(true)
        userService.login(email: "", password: "") { [weak self] result in
            switch result {
            case .success(let u):
                self?.view?.show(user: u)
            case .failure(let e):
                self?.view?.show(error: e.description)
            }
            self?.view?.showLoading(false)
        }
    }
}
