import Foundation

extension String {

    /// Get rexeg matches
    /// - Parameter regex: regex expression
    /// - Returns: Array of matches
    public func matches(regex: String) throws -> [String]? {
        let range = NSRange(location: 0, length: self.utf16.count)
            let regex = try NSRegularExpression(pattern: regex)
        let matches = regex.matches(in: self, range: range)

        let result: [String]? = matches.map { m in
            (self as NSString).substring(with: m.range(at: 0))
        }
        return result!.count > 0 ? result : nil
    }

    /// Gets unnamed regex capture groups
    /// - Parameter regex: regex expression
    /// - Returns: Array of matches
    public func matchUnnamedGroups(regex: String) throws -> [String]? {
        let range = NSRange(location: 0, length: self.utf16.count)
            let regex = try NSRegularExpression(pattern: regex)
        let matches = regex.matches(in: self, range: range)

        guard let first = matches.first else {
            return nil
        }

        guard first.numberOfRanges == 1 else {
            var names: [String] = []
            for match in matches {
                for rangeIndex in 1..<match.numberOfRanges {
                    let matchRange = match.range(at: rangeIndex)
                    if matchRange == range { continue }
                    if let substringRange = Range(matchRange, in: self) {
                        let capture = String(self[substringRange])
                        names.append(capture)
                    }
                }
            }

            return names
        }

        return nil
    }

    /// Gets named regex capture groups
    /// - Parameter regex: regex expression
    /// - Returns: Dictionary with group name as key and its value
    public func matchNamedGroups(regex: String) throws -> [[String: String]]? {
        guard let groups = try regex.matchUnnamedGroups(regex: "\\(\\?<(\\w+)>") else {
            return nil
        }

        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try NSRegularExpression(pattern: regex)

        guard let _ = regex.matches(in: self, range: range).first else {
            return nil
        }

        let matches = regex.matches(in: self, range: range)

        var result: [[String: String]] = []

        for match in matches {
            result.append([:])
            let index = result.count - 1
            for group in groups {
                let matchRange = match.range(withName: group)
                if let substringRange = Range(matchRange, in: self) {
                    let capture = String(self[substringRange])
                    result[index][group] = capture
                }
            }
            if result.last!.isEmpty {
                result.removeLast()
            }
        }

        return result
    }

}
