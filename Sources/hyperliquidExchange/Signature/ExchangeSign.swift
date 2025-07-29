//
//  ExchangeSign.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
import Foundation
import Secp256k1Swift
import SwiftMsgpack
import web3swift
import CryptoSwift
import Blake2

public enum ExchangeSignError: Error {
    case invalidPrivateData
    case signError
}
public struct ExchangeKeychain{
    public var privateData: Data
    public var publicData: Data
    public init(privateData: Data) throws {
        self.privateData = privateData
        guard let publicKey = SECP256K1.privateToPublic(privateKey: privateData, compressed: false) else {
            throw ExchangeSignError.invalidPrivateData
        }
        self.publicData = publicKey
    }
    
    public func sign(msgHash: Data) throws -> Data {
        let signedData = SECP256K1.signForRecovery(hash: msgHash, privateKey: privateData, useExtraVer: true)
        guard let signData = signedData.serializedSignature else {
            throw ExchangeSignError.signError
        }
        return signData
    }
}
public struct ExchangeSign {
    public var keypair: ExchangeKeychain
    public init(keypair: ExchangeKeychain) {
        self.keypair = keypair
    }
    public func sign_l1_action(action: ExchangeBaseAction, vaultAddress: String?, nonce: Int, expiresAfter: Int?, isMainnet: Bool = true) throws -> Data {
        let hash = try action_hash(action: action, vaultAddress: vaultAddress, nonce: nonce, expiresAfter: expiresAfter)
        let phantom_agent = constructPhantomAgent(hash: hash.toHexString(), isMainnet: isMainnet)
        let l1Payload = l1Payload(phantomAgent: phantom_agent)
        let typedData = try makeEIP712TypedData(from: l1Payload)
        return try self.keypair.sign(msgHash: typedData)
    }
    
    public func action_hash(action: ExchangeBaseAction, vaultAddress: String?, nonce: Int, expiresAfter: Int?) throws -> Data{
        let encoder = MsgPackEncoder()
        var data = Data()
        data.append(try encoder.encode(action))
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
        if let expires = expiresAfter {
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
   
    public func makeEIP712TypedData(from dict: [String: Any]) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        let eip712TypedData = try decoder.decode(EIP712TypedData.self, from: data)
        return try eip712TypedData.digestData()
    }
}

extension ExchangeSign {
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
