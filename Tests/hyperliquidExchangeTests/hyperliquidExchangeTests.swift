import Testing
import Foundation
import XCTest
@testable import hyperliquidExchange
@testable import SwiftMsgpack

@Test func test_limit_encode() throws {
    let order = ExchangeOrderType.limit(ExchangeLimitTif(tif: .Gtc))
    let data = try JSONEncoder().encode(order)
    print(String(data: data, encoding: .utf8)!)
}

@Test func test_order_sign() throws {
    let keypair = try ExchangeKeychain(privateData: Data(hex: "0x0123456789012345678901234567890123456789012345678901234567890123"))
    let place_order_payload = ExchangePlaceOrderPayload(a: 1, b: true, p: "100", r: false, s: "100", t: .limit(ExchangeLimitTif(tif: .Gtc)))
    let place_order = ExchangePlaceOrderAction(orders: [place_order_payload], grouping: .na)
    let orderRequest = ExchangeRequest(action: place_order, nonce: 0)
    let sigData = try ExchangeSign(keypair: keypair).sign_l1_action(action: orderRequest.action, vaultAddress: orderRequest.vaultAddress, nonce: orderRequest.nonce, expiresAfter: orderRequest.expiresAfter)
    assert(sigData.toHexString() == "d65369825a9df5d80099e513cce430311d7d26ddf477f5b3a33d2806b100d78e2b54116ff64054968aa237c20ca9ff68000f977c93289157748a3162b6ea940e1c")
}

@Test func test_usdc_sign() throws {
    let keypair = try ExchangeKeychain(privateData: Data(hex: "0x0123456789012345678901234567890123456789012345678901234567890123"))
    let action = [
        "destination": "0x5e9ee1089755c3435139848e47e6635505d5a13a",
        "amount": "1",
        "time": 1687816341423,
        "signatureChainId": "0x66eee"
    ] as [String : Any]
    let sigData = try ExchangeSign(keypair: keypair).sign_user_signed_action(action: action, actionType: .UsdSend, isMainnet: false)
    let signature = ExchangeSignature.parseSignatureHex(sigData.toHexString())!
    XCTAssertTrue(signature.r == "0x637b37dd731507cdd24f46532ca8ba6eec616952c56218baeff04144e4a77073")
    XCTAssertTrue(signature.s == "0x11a6a24900e6e314136d2592e2f8d502cd89b7c15b198e1bee043c9589f9fad7")
    XCTAssertTrue(signature.v == 27)
}
