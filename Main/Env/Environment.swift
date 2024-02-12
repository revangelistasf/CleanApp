import Foundation

public final class Environment {
    public enum EnvironmentVariables: String {
        // Maybe should add test for check if all cases on this enum are really created variables.
        case apiBaseUrl = "API_BASE_URL"
    }
    
    public static func variable(_ key: EnvironmentVariables) -> String {
        Bundle.main.infoDictionary?[key.rawValue] as? String ?? ""
    }
}
