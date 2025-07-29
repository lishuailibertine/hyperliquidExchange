import Testing
import Foundation
@testable import hyperliquidExchange
@testable import SwiftMsgpack

@Test func testEncode() throws {
    let order = ExchangeOrderType.limit(ExchangeLimitTif(tif: .Gtc))
    let data = try JSONEncoder().encode(order)
    print(String(data: data, encoding: .utf8)!)
}

@Test func testOrderSign() throws {
    let keypair = try ExchangeKeychain(privateData: Data(hex: "0x0123456789012345678901234567890123456789012345678901234567890123"))
    let place_order_payload = ExchangePlaceOrderPayload(a: 1, b: true, p: "100", r: false, s: "100", t: .limit(ExchangeLimitTif(tif: .Gtc)))
    let place_order = ExchangePlaceOrderAction(orders: [place_order_payload], grouping: .na)
    let orderRequest = ExchangeRequest(action: place_order, nonce: 0)
    let hashHex = try orderRequest.action_hash().toHexString()
    print(hashHex)
}
