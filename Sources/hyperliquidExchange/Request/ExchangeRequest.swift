//
//  ExchangeRequest.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
import Foundation
import SwiftMsgpack
import web3swift
import CryptoSwift
public protocol ExchangeEncodePayload {
    func payload() throws -> [String: Any]
}

public enum ExchangeRequestError: Error {
    case SignatureError
}

public struct ExchangeRequest: ExchangeEncodePayload, Encodable{
    public var action: ExchangeBaseAction
    public var nonce: Int // Recommended to use the current timestamp in milliseconds
    public var signature: ExchangeSignature?
    public var vaultAddress: String? // If trading on behalf of a vault or subaccount, its address in 42-character hexadecimal format; e.g. 0x0000000000000000000000000000000000000000
    public var expiresAfter: Int?
    
    public init(action: ExchangeBaseAction, nonce: Int, signature: ExchangeSignature? = nil, vaultAddress: String? = nil, expiresAfter: Int? = nil) {
        self.action = action
        self.nonce = nonce
        self.signature = signature
        self.vaultAddress = vaultAddress
        self.expiresAfter = expiresAfter
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(try action.payload(), forKey: .action)
        try container.encode(nonce, forKey: .nonce)
        guard let signature = try signature?.payload() else {
            throw ExchangeRequestError.SignatureError
        }
        try container.encode(signature, forKey: .signature)
        try container.encodeIfPresent(vaultAddress, forKey: .vaultAddress)
        if let expiresAfter = self.expiresAfter {
            try container.encode(expiresAfter, forKey: .expiresAfter)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case action
        case nonce
        case signature
        case vaultAddress
        case expiresAfter
    }
}
