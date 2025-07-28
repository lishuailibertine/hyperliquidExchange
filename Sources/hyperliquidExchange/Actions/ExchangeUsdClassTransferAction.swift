//
//  ExchangeUsdClassTransfer.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//

public struct ExchangeUsdClassTransferAction: ExchangeBaseAction {
    public var type: String = "usdClassTransfer"
    public var hyperliquidChain: String = "Mainnet" // "Mainnet" (on testnet use "Testnet" instead)
    public var signatureChainId: String = "0xa4b1" // default Arbitrum
    public var amount: String // amount of usd to transfer as a string
    public var toPerp: Bool = true //  true if (spot -> perp) else false
    public var nonce: Int // current timestamp in milliseconds as a Number, must match nonce in outer request body
    public func payload() -> [String : Any] {
        return [:]
    }
}
