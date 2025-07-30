//
//  ExchangeSpotSendAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/30.
//

import Foundation
public struct ExchangeSpotSendAction: Encodable, ExchangeBaseAction {
    public var amount: String // amount of token to send as a string, e.g. "0.01"
    public var destination: String
    public var hyperliquidChain: String // "Mainnet" (on testnet use "Testnet" instead)
    public var signatureChainId: String // default Arbitrum
    public var time: Int // current timestamp in milliseconds as a Number, should match nonce
    public var type: String
    public var token: String //  tokenName:tokenId
    public init(amount: String, destination: String, hyperliquidChain: String = "Mainnet", signatureChainId: String = "0xa4b1", time: Int = Int(Date().timeIntervalSince1970 * 1000), type: String = "spotSend", token: String) {
        self.amount = amount
        self.destination = destination
        self.hyperliquidChain = hyperliquidChain
        self.signatureChainId = signatureChainId
        self.time = time
        self.type = type
        self.token = token
    }
}
