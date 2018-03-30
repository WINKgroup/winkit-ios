//___FILEHEADER___

import WinkKit

/// The protocol that the view controller handled by presenter must conforms to.
protocol ___VARIABLE_UseCaseName___View: PresentableView {
    
}

/// The presenter that will handle all logic of the view.
class ___VARIABLE_UseCaseName___Presenter: WKGenericViewControllerPresenter {
    
    typealias View = ___VARIABLE_UseCaseName___View
    
    // The view associated to this presenter.
    weak var view: ___VARIABLE_UseCaseName___View?

    required init() {
        // Required empty initializer, put here other init stuff
    }
}
