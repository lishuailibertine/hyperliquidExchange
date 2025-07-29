//
//  ExchangeSign+.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/29.
//
import Foundation
import CryptoSwift
// sign_l1_action
extension ExchangeSign {
    public func sign_l1_action(action: ExchangeBaseAction, vaultAddress: String?, nonce: Int, expiresAfter: Int?, isMainnet: Bool = true) throws -> Data {
        let hash = try action_hash(action: action, vaultAddress: vaultAddress, nonce: nonce, expiresAfter: expiresAfter)
        let phantom_agent = constructPhantomAgent(hash: hash.toHexString(), isMainnet: isMainnet)
        let l1Payload = l1Payload(phantomAgent: phantom_agent)
        return try self.sign_inner(structured_data: l1Payload)
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
// sign_user_signed_action
extension ExchangeSign {
    public enum UserActionType: String {
        case UsdClassTransfer = "HyperliquidTransaction:UsdClassTransfer"
        case UsdSend = "HyperliquidTransaction:UsdSend"
        public func SIGN_TYPES() -> [Any] {
            switch self {
            case .UsdClassTransfer:
                return ExchangeSign.USD_CLASS_TRANSFER_SIGN_TYPES()
            case .UsdSend:
                return ExchangeSign.USD_SEND_SIGN_TYPES()
            }
        }
    }
    
    public func sign_user_signed_action(action: ExchangeBaseAction, actionType: UserActionType = .UsdClassTransfer, isMainnet: Bool = true) throws -> Data{
        let action = try action.payload()
        return try self.sign_user_signed_action_with_dic(action: action, primary_type: actionType.rawValue, payload_types: actionType.SIGN_TYPES(), isMainnet: isMainnet)
    }
    
    public func sign_user_signed_action(action: [String: Any], actionType: UserActionType = .UsdClassTransfer, isMainnet: Bool = true) throws -> Data {
        return try self.sign_user_signed_action_with_dic(action: action, primary_type: actionType.rawValue, payload_types: actionType.SIGN_TYPES(), isMainnet: isMainnet)
    }
    
    public func sign_user_signed_action_with_dic(action: [String: Any], primary_type: String, payload_types: [Any], isMainnet: Bool = true) throws -> Data {
        let user_signed_payload = try user_signed_payload(action: action, primary_type: primary_type, payload_types: payload_types, isMainnet: isMainnet)
        return try self.sign_inner(structured_data: user_signed_payload)
    }
    
    public func user_signed_payload(action: [String: Any], primary_type: String, payload_types: [Any], isMainnet: Bool = true) throws -> [String: Any] {
        var newAction = action
        newAction["hyperliquidChain"] = isMainnet ? "Mainnet" : "Testnet"
        guard let signatureChainId = action["signatureChainId"] as? String,
              let chain_id = Int(signatureChainId.replacingOccurrences(of: "0x", with: ""), radix: 16) else {
            throw ExchangeSignError.invaildChainId
        }
       
        return [
            "domain": [
                "name": "HyperliquidSignTransaction",
                "version": "1",
                "chainId": chain_id,
                "verifyingContract": "0x0000000000000000000000000000000000000000"
            ],
            "types": [
                primary_type: payload_types,
                "EIP712Domain": [
                    ["name": "name", "type": "string"],
                    ["name": "version", "type": "string"],
                    ["name": "chainId", "type": "uint256"],
                    ["name": "verifyingContract", "type": "address"]
                ]
            ],
            "primaryType": primary_type,
            "message": newAction
        ]
    }
    
    static func USD_CLASS_TRANSFER_SIGN_TYPES() -> [Any] {
       return [
            ["name": "hyperliquidChain", "type": "string"],
            ["name": "amount", "type": "string"],
            ["name": "toPerp", "type": "bool"],
            ["name": "nonce", "type": "uint64"],
        ]
    }
    
    static func USD_SEND_SIGN_TYPES() -> [Any] {
        return [
            ["name": "hyperliquidChain", "type": "string"],
            ["name": "destination", "type": "string"],
            ["name": "amount", "type": "string"],
            ["name": "time", "type": "uint64"],
        ]
    }
}
