//
//  ExchangeSign.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/28.
//
import Foundation
import web3swift
import Secp256k1Swift
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
    
}
