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
    let sigData = try ExchangeSign(keypair: keypair).sign_l1_action(action: orderRequest.action, vaultAddress: orderRequest.vaultAddress, nonce: orderRequest.nonce, expiresAfter: orderRequest.expiresAfter)
    assert(sigData.toHexString() == "d65369825a9df5d80099e513cce430311d7d26ddf477f5b3a33d2806b100d78e2b54116ff64054968aa237c20ca9ff68000f977c93289157748a3162b6ea940e1c")
}
