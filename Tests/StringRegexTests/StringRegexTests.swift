import XCTest
@testable import StringRegex

final class StringRegexTests: XCTestCase {
    func testEmpty() {
        let s = ""
        let regex = "\\w"
        let matches = s.matches(regex: regex)
        XCTAssertNil(matches)
    }
    
    func testRegexMultiple() {
        let s = "Hello World!"
        let regex = "\\w+"
        let matches = s.matches(regex: regex)
        XCTAssertEqual(matches, ["Hello", "World"])
    }
    
    func testRegexMixed() {
        let s = "Hello 2 World! 123 456."
        let regex = "[[:alpha:]]+|[[:digit:]]+"
        let matches = s.matches(regex: regex)
        XCTAssertEqual(matches, ["Hello", "2", "World", "123", "456"])
    }
    
    func testRegexUnamedGroups() {
        let s = "The quick brown fox jumps over the lazy dog."
        let regex = "(fox).*(dog).*"
        let matches = s.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches, ["fox", "dog"])
    }
    
    func testRegexUnamedGroupsTokens() {
        let s = "The quick brown fox jumps over the lazy dog."
        let regex = "(\\w+)"
        let matches = s.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches, ["The", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog"])
    }
    
    func testGroupsEmpty() {
        let s = ""
        let regex = "(\\w+)"
        let matches = s.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches.isEmpty, true)
    }
    
    func testRegexEmptyNamedGroups() {
        let s = ""
        let regex = "(?<forname>John)\\s*(?<surname>Doe)"
        let matches = s.matchNamedGroups(regex: regex)
        XCTAssertNil(matches)
    }
    
    func testRegexNamedGroups() {
        let s = "John Doe"
        let regex = "(?<forname>\\w+)\\s+(?<surname>\\w+)"
        let matches = s.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, ["forname": "John", "surname": "Doe"])
    }
    
    func testRegexMixedUnamedNamedGroups() {
        let s = "John Peter Doe"
        let regex = "(?<forename>\\w+)\\s+(\\w+)\\s+(?<surname>\\w+)"
        let matches = s.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, ["forename": "John", "surname": "Doe"])
    }
}
