
import Foundation

extension NSRegularExpression {
 
    func firstMatchingString(in string: String) -> String? {
        let searchRange = NSRange(location: 0, length: string.count)
        
        guard
            let match = firstMatch(in: string, options: [], range: searchRange),
            let matchRange = Range(match.range, in: string)
        else {
            return nil
        }
        
        return String(string[matchRange])
    }
    
}
