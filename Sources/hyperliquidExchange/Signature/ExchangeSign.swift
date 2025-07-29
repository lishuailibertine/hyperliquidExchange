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
    case invaildChainId
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
    
    public func sign_inner(structured_data: [String: Any]) throws -> Data {
        let typedData = try makeEIP712TypedData(from: structured_data)
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
  
    public func makeEIP712TypedData(from dict: [String: Any]) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        let eip712TypedData = try decoder.decode(EIP712TypedData.self, from: data)
        return try eip712TypedData.digestData()
    }
}
