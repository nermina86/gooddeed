import XCTest
@testable import gooddeed

final class GoodDeedTests: XCTestCase {

    override func setUpWithError() throws {
        // Pokreće se prije svakog testa
    }

    override func tearDownWithError() throws {
        // Pokreće se nakon svakog testa
    }

    func testSum() throws {
        let result = 2 + 2
        XCTAssertEqual(result, 4, "Zbir nije tačan")
    }

    func testLaunchPerformance() throws {
        measure {
            // Ovdje pokreni kod koji mjeriš
            _ = 1...10_000.map { $0 * 2 }
        }
    }

    func testLoginValidation() throws {
        let email = "test@example.com"
        let password = "123456"
        XCTAssertTrue(email.contains("@") && password.count >= 6)
    }
}
