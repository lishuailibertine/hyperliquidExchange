//
//  ExchangeRequest.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
public struct ExchangeSignature: ExchangeEncodePaload, Encodable{
    public var r: String
    public var s: String
    public var v: Int
}
public protocol ExchangeEncodePaload {
    func payload() throws -> [String: Any?]
}
public struct ExchangeRequest: ExchangeEncodePaload{
    public var action: ExchangeBaseAction
    public var nonce: Int // Recommended to use the current timestamp in milliseconds
    public var signature: ExchangeSignature
    public var vaultAddress: String? // If trading on behalf of a vault or subaccount, its address in 42-character hexadecimal format; e.g. 0x0000000000000000000000000000000000000000
    public var expiresAfter: Int?
    
    public func payload() throws -> [String : Any?] {
        var body: [String: Any] = [:]
        body["action"] = try self.action.payload()
        body["nonce"] = self.nonce
        body["signature"] = try self.signature.payload()
        body["vaultAddress"] =  self.vaultAddress
        if let expiresAfter = self.expiresAfter {
            body["expiresAfter"] =  expiresAfter
        }
        return body
    }
}
