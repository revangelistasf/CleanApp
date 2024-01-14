import Foundation
import Presentation

func makeMandatoryAlertViewModel(fieldName: String) -> AlertViewModel {
    AlertViewModel(title: "Validation Failed", message: "The field \(fieldName) is mandatory")
}

func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
    AlertViewModel(title: "Validation Failed", message: "Please enter a valid \(fieldName) field")
}

func makeErrorAlertViewModel(message: String) -> AlertViewModel {
    AlertViewModel(title: "Error", message: message)
}

func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
    AlertViewModel(title: "Success", message: message)
}
