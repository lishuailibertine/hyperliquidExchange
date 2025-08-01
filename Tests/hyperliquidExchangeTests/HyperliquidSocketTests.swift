//
//  HyperliquidSocketTests.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/31.
//
import XCTest
import Foundation
@testable import hyperliquidExchange

class SocketTests: XCTestCase {
    func test_socket() {
        let expectation = XCTestExpectation(description: "Wait for async task")
        let socket = HyperliquidSocket()
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            debugPrint(socket.isConnected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }
}

