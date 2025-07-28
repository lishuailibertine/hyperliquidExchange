//
//  ExchangeUsdClassTransfer.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
import Foundation
public struct ExchangeUsdClassTransferAction: ExchangeBaseAction, Encodable{
    public var type: String
    public var hyperliquidChain: String // "Mainnet" (on testnet use "Testnet" instead)
    public var signatureChainId: String // default Arbitrum
    public var amount: String // amount of usd to transfer as a string
    public var toPerp: Bool //  true if (spot -> perp) else false
    public var nonce: Int // current timestamp in milliseconds as a Number, must match nonce in outer request body
    public init(type: String = "usdClassTransfer", hyperliquidChain: String = "Mainnet" , signatureChainId: String = "0xa4b1", amount: String, toPerp: Bool = true, nonce: Int = Int(Date().timeIntervalSince1970 * 1000)) {
        self.type = type
        self.hyperliquidChain = hyperliquidChain
        self.signatureChainId = signatureChainId
        self.amount = amount
        self.toPerp = toPerp
        self.nonce = nonce
    }
}
