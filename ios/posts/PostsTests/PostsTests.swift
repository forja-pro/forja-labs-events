import Testing
@testable import Posts

struct PostsTests {

    @Test func example() async throws {
        // Example test showing basic testing syntax
        let expectedValue = 42
        let actualValue = 42
        
        #expect(actualValue == expectedValue)
    }
    
    @Test func testArticleBasicProperties() async throws {
        // Example test for the Article model
        let article = Article(id: 1, title: "Test Article", author: "Test Author")
        
        #expect(article.id == 1)
        #expect(article.title == "Test Article")
        #expect(article.author == "Test Author")
    }

}
