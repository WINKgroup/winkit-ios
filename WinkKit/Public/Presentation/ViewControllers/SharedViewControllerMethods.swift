//
//  SharedViewControllerMethods.swift
//  Alamofire
//
//  Created by Rico Crescenzio on 07/04/2019.
//

import UIKit

struct SharedViewControllerMethods {

    static func presenter<VC: UIViewController & WKBaseViewController>(for viewController: VC) -> VC.P {
        typealias Presenter = VC.P
        typealias View = VC.P.View
        typealias InitObject = VC.P.InitObject
        var viewController = viewController
        if Presenter.self == VoidPresenter.self {
            return VoidPresenter() as! Presenter
        } else if let view = viewController as? View {
            var presenter: Presenter? = nil
            if InitObject.self == Void.self {
                presenter = .init(view: view, initObject: () as! InitObject)
            }
            if let type = InitObject.self as? OptionalProtocol.Type {
                if type.deepestWrappedType == Void.self {
                    presenter = .init(view: view, initObject: () as! InitObject)
                }
                let nilInitObject = Optional<InitObject>.none as! InitObject
                presenter = .init(view: view, initObject: nilInitObject)
            }
            if let initObject = viewController.initObject {
                presenter = .init(view: view, initObject: initObject)
            }
            if let presenter = presenter {
                viewController.initObject = nil
                return presenter
            }
            print("❌ \(type(of: viewController)): The current `initObject` parameter is \(String(describing: viewController.initObject)), but \(Presenter.self).init requires a `initObject` of type \(InitObject.self); this error is typically thrown when a view controller is instantiated without using the static instantiation feature and the `initPresenter()` method in your view controller has not been overriden.\n")
        } else {
            print("❌ \(type(of: viewController)) doesn't conform to \(type(of: View.self))")
        }
        fatalError()
    }
    
}

