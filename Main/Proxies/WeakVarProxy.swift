import Foundation
import Presentation

final class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    init(_ instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: AlertView where T: AlertView {
    func showMessage(viewModel: Presentation.AlertViewModel) {
        instance?.showMessage(viewModel: viewModel)
    }
}

extension WeakVarProxy: LoadingView where T: LoadingView {
    func display(viewModel: Presentation.LoadingViewModel) {
        instance?.display(viewModel: viewModel)
    }
}
