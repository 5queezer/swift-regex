import XCTest
@testable import StringRegex

final class StringRegexTests: XCTestCase {
    func testEmpty() throws {
        let s = ""
        let regex = "\\w"
        let matches = try s.matches(regex: regex)
        XCTAssertNil(matches)
    }

    func testRegexMultiple() throws {
        let s = "Hello World!"
        let regex = "\\w+"
        let matches = try s.matches(regex: regex)
        XCTAssertEqual(matches, ["Hello", "World"])
    }

    func testRegexMixed() throws {
        let s = "Hello 2 World! 123 456."
        let regex = "[[:alpha:]]+|[[:digit:]]+"
        let matches = try s.matches(regex: regex)
        XCTAssertEqual(matches, ["Hello", "2", "World", "123", "456"])
    }

    func testRegexUnamedGroups() throws {
        let s = "The quick brown fox jumps over the lazy dog."
        let regex = "(fox).*(dog).*"
        let matches = try s.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches, ["fox", "dog"])
    }

    func testRegexUnamedGroupsTokens() throws {
        let s = "The quick brown fox jumps over the lazy dog."
        let regex = "(\\w+)"
        let matches = try s.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches, ["The", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog"])
    }

    func testRegexUnamedGroupsEmpty() throws {
        let s = ""
        let regex = "(\\w+)"
        let matches = try s.matchUnnamedGroups(regex: regex)
        XCTAssertNil(matches)
    }

    func testRegexEmptyNamedGroups() throws {
        let s = ""
        let regex = "(?<forname>John)\\s*(?<surname>Doe)"
        let matches = try s.matchNamedGroups(regex: regex)
        XCTAssertNil(matches)
    }

    func testRegexNamedGroups() throws {
        let s = "John Doe"
        let regex = "(?<forname>\\w+)\\s+(?<surname>\\w+)"
        let matches = try s.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, [["forname": "John", "surname": "Doe"]])
    }

    func testRegexNamedMultipleGroups() throws {
        let s = """
                foo0 = bar0
                foo1 = bar1
                """
        let regex = "(?<key>\\w+) = (?<value>\\w+)"
        let matches = try s.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, [
            ["key": "foo0", "value": "bar0"],
            ["key": "foo1", "value": "bar1"]
        ])
    }

    func testRegexMixedUnamedNamedGroups() throws {
        let s = "John Peter Doe"
        let regex = "(?<forename>\\w+)\\s+(\\w+)\\s+(?<surname>\\w+)"
        let matches = try s.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, [["forename": "John", "surname": "Doe"]])
    }
    
    func testRegexThrowOnInvalidRegex() throws {
        let s = "The quick brown fox jumps over the lazy {animal}."
        
        // Brackets as strings must be escaped
        var regex = "{\\w+}"
        XCTAssertThrowsError(try s.matches(regex: regex))
        
        // Unmached parantheses
        regex = "(\\w+"
        XCTAssertThrowsError(try s.matchUnnamedGroups(regex: regex))
        
        // Brackets as quantifier must contain an integer
        regex = "(?<token>.*{\\w})"
        XCTAssertThrowsError(try s.matchNamedGroups(regex: regex))
    }
}
