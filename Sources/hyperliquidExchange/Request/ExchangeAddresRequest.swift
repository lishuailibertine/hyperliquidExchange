//
//  ExchangeAddresRequest.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/31.
//
import Foundation
// https://docs.hyperunit.xyz/developers/api/generate-address
public struct ExchangeAddresRequest {
    public var src_chain: String // source chain ("bitcoin", "solana", "ethereum", or "hyperliquid")
    public var dst_chain: String // destination chain ("bitcoin", "solana", "ethereum", or "hyperliquid")
    public var asset: String // asset symbol ("btc", "eth", "sol", or "fart")
    public var dst_addr: String // destination address.
    
    public init(src_chain: String, dst_chain: String, asset: String, dst_addr: String) {
        self.src_chain = src_chain
        self.dst_chain = dst_chain
        self.asset = asset
        self.dst_addr = dst_addr
    }
    
    public func pathValue() -> String {
        return "/\(src_chain)/\(dst_chain)/\(asset)/\(dst_addr)"
    }
    
}
