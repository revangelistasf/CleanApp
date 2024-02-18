import Presentation

public final class CompareFieldsValidation: Validation {
    private let fieldName: String
    private let fieldNameToCompare: String
    private let fieldLabel: String
    
    public init(fieldName: String, fieldNameToCompare: String, fieldLabel: String) {
        self.fieldName = fieldName
        self.fieldNameToCompare = fieldNameToCompare
        self.fieldLabel = fieldLabel
    }
    
    public func validate(data: [String: Any]?) -> String? {
        guard 
            let fieldValue = data?[fieldName] as? String,
            let fieldValueToCompare = data?[fieldNameToCompare] as? String,
            fieldValue == fieldValueToCompare
        else {
            return "The field \(fieldLabel) is invalid"
        }
        return nil
    }
}
