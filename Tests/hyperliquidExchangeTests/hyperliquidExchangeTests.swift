import Testing
import Foundation
@testable import hyperliquidExchange

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func testEncode() throws {
    let order = ExchangeOrderType.limit(ExchangeLimitOrderType.Gtc)
    let data = try JSONEncoder().encode(order)
    print(String(data: data, encoding: .utf8)!)
}
