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
public struct ExchangeSignature: ExchangeEncodePayload, Encodable{
    public var r: String
    public var s: String
    public var v: Int
}
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

extension ExchangeRequest{
    
    public func action_hash() throws -> Data{
        let encoder = MsgPackEncoder()
        var data = Data()
        data.append(try encoder.encode(self.action))
        // Add nonce as 8-byte big-endian
        let nonceBytes = withUnsafeBytes(of: nonce.bigEndian, Array.init)
        data.append(contentsOf: nonceBytes)
        // Vault address
        if let address = vaultAddress, let addressData = EthereumAddress(address)?.addressData {
            data.append(0x01)
            data.append(contentsOf: addressData)
        } else {
            data.append(0x00)
        }
        // Expires after
        if let expires = self.expiresAfter {
            data.append(0x00)
            let expiresBytes = withUnsafeBytes(of: expires.bigEndian, Array.init)
            data.append(contentsOf: expiresBytes)
        }
        return data.sha3(.keccak256)
    }
    
    public func constructPhantomAgent(hash: String, isMainnet: Bool) -> [String: String] {
        return [
            "source": isMainnet ? "a" : "b",
            "connectionId": hash
        ]
    }
    
    public func l1Payload(phantomAgent: [String: Any]) -> [String: Any] {
        return [
            "domain": [
                "chainId": 1337,
                "name": "Exchange",
                "verifyingContract": "0x0000000000000000000000000000000000000000",
                "version": "1"
            ],
            "types": [
                "Agent": [
                    ["name": "source", "type": "string"],
                    ["name": "connectionId", "type": "bytes32"]
                ],
                "EIP712Domain": [
                    ["name": "name", "type": "string"],
                    ["name": "version", "type": "string"],
                    ["name": "chainId", "type": "uint256"],
                    ["name": "verifyingContract", "type": "address"]
                ]
            ],
            "primaryType": "Agent",
            "message": phantomAgent
        ]
    }
}
