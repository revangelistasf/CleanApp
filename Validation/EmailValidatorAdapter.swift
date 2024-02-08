import Foundation
import Presentation

public final class EmailValidatorAdapter: EmailValidator {
    private let regexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    public init() {}
    
    public func isValid(email: String) -> Bool {
        // utf16 because using count itself could has some problems to count with emojis
        let range = NSRange(location: 0, length: email.utf16.count)
        let regex = try? NSRegularExpression(pattern: regexPattern)
        return regex?.firstMatch(in: email, range: range) != nil
    }
}
