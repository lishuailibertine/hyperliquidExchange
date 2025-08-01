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
import BIP39swift
import BIP32Swift
public enum ExchangeSignError: Error {
    case invalidPrivateData
    case invalidPublicData
    case invalidMnemonic
    case signError
    case invaildChainId
}
public struct ExchangeKeychain{
    public var privateData: Data
    public var publicData: Data
    static let DEFAULT_PATH = "m/44'/60'/0'/0/0"
    public init(mnemonics: String) throws {
        guard let seed = BIP39.seedFromMmemonics(mnemonics) else {
            throw ExchangeSignError.invalidMnemonic
        }
        guard let node = HDNode(seed: seed), let treeNode = node.derive(path: ExchangeKeychain.DEFAULT_PATH) else {
            throw ExchangeSignError.invalidMnemonic
        }
        guard let privateKey = treeNode.privateKey else {
            throw ExchangeSignError.invalidPrivateData
        }
        try self.init(privateData: privateKey)
    }
    
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
    
    public func address() throws -> String {
        guard let address = Web3.Utils.publicToAddress(self.publicData) else {
            throw ExchangeSignError.invalidPublicData
        }
        return address.address
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
