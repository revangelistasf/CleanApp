import Presentation

public final class RequiredFieldValidation: Validation {
    private let fieldName: String
    private let fieldLabel: String
    
    public init(fieldName: String, fieldLabel: String) {
        self.fieldName = fieldName
        self.fieldLabel = fieldLabel
    }
    
    public func validate(data: [String : Any]?) -> String? {
        guard let fieldValue = data?[fieldName] as? String, !fieldValue.isEmpty else {
            return "The field \(fieldLabel) is mandatory"
        }
        
        return nil
    }
}
