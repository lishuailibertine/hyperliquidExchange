//
//  ExchangeWithdrawAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/30.
//

import Foundation
public struct ExchangeWithdrawAction: Encodable, ExchangeBaseAction {
    public var amount: String // amount of usd to send as a string, e.g. "1" for 1 usd,
    public var destination: String // address in 42-character hexadecimal format; e.g. 0x0000000000000000000000000000000000000000
    public var hyperliquidChain: String // "Mainnet" (on testnet use "Testnet" instead)
    public var signatureChainId: String // default Arbitrum
    public var time: Int // current timestamp in milliseconds as a Number, should match nonce,
    public var type: String
    init(amount: String, destination: String, hyperliquidChain: String = "Mainnet", signatureChainId: String, time: Int = Int(Date().timeIntervalSince1970 * 1000), type: String = "withdraw3") {
        self.amount = amount
        self.destination = destination
        self.hyperliquidChain = hyperliquidChain
        self.signatureChainId = signatureChainId
        self.time = time
        self.type = type
    }
}
