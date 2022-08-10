import XCTest
@testable import StringRegex

final class StringRegexTests: XCTestCase {
    func testEmpty() throws {
        let testString = ""
        let regex = "\\w"
        let matches = try testString.matches(regex: regex)
        XCTAssertNil(matches)
    }

    func testRegexMultiple() throws {
        let testString = "Hello World!"
        let regex = "\\w+"
        let matches = try testString.matches(regex: regex)
        XCTAssertEqual(matches, ["Hello", "World"])
    }

    func testRegexMixed() throws {
        let testString = "Hello 2 the World!"
        let regex = "[[:alpha:]]+|[[:digit:]]+"
        let matches = try testString.matches(regex: regex)
        XCTAssertEqual(matches, ["Hello", "2", "the", "World"])
    }

    func testRegexUnnamedGroups() throws {
        let testString = "The quick brown fox jumps over the lazy dog."
        let regex = "(\\w+){1}.*(?<=\\s)(\\w+)"
        let matches = try testString.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches, ["The", "dog"])
    }

    func testRegexUnnamedGroupsTokens() throws {
        let testString = "The quick brown fox jumps over the lazy dog."
        let regex = "(\\w+)"
        let matches = try testString.matchUnnamedGroups(regex: regex)
        XCTAssertEqual(matches, ["The", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog"])
    }

    func testRegexUnnamedGroupsEmpty() throws {
        let testString = "👻"
        let regex = "(\\w+)"
        let matches = try testString.matchUnnamedGroups(regex: regex)
        XCTAssertNil(matches)
    }

    func testRegexEmptyNamedGroups() throws {
        let testString = "John Doe"
        let regex = "(?<forename>Peter)\\s+(?<surname>Doe)"
        let matches = try testString.matchNamedGroups(regex: regex)
        XCTAssertNil(matches)
    }

    func testRegexNamedGroups() throws {
        let testString = "John Doe"
        let regex = "(?<forename>\\w+)\\s+(?<surname>\\w+)"
        let matches = try testString.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, [["forename": "John", "surname": "Doe"]])
    }

    func testRegexNamedMultipleGroups() throws {
        let testString = """
                [section]
                foo0 = bar0;
                foo1 = bar1;
                """
        let regex = "(?<key>\\w+) = (?<value>\\w+)"
        let matches = try testString.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, [
            ["key": "foo0", "value": "bar0"],
            ["key": "foo1", "value": "bar1"]
        ])
    }

    func testRegexMixedUnnamedNamedGroups() throws {
        let testString = "John Peter Doe"
        let regex = "(?<forename>\\w+)\\s+(\\w+)\\s+(?<surname>\\w+)"
        let matches = try testString.matchNamedGroups(regex: regex)
        XCTAssertEqual(matches!, [["forename": "John", "surname": "Doe"]])
    }
    
    func testRegexThrowOnInvalidRegex() throws {
        let testString = "The quick brown fox jumps over the lazy {animal}."
        
        // Brackets as strings must be escaped
        var regex = "{\\w+}"
        XCTAssertThrowsError(try testString.matches(regex: regex))
        
        // Unmatched parentheses
        regex = "(\\w+"
        XCTAssertThrowsError(try testString.matchUnnamedGroups(regex: regex))
        
        // Brackets as quantifier must contain an integer
        regex = "(?<token>{a})"
        XCTAssertThrowsError(try testString.matchNamedGroups(regex: regex))
    }
}
