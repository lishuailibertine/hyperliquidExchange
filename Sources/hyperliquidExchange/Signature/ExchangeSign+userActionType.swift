//
//  ExchangeSign+userActionType.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/30.
//
import Foundation
extension ExchangeSign {
    public enum UserActionType: String {
        case UsdClassTransfer = "HyperliquidTransaction:UsdClassTransfer"
        case UsdSend = "HyperliquidTransaction:UsdSend"
        case Withdraw = "HyperliquidTransaction:Withdraw"
        case SpotSend = "HyperliquidTransaction:SpotSend"
        public func SIGN_TYPES() -> [Any] {
            switch self {
            case .UsdClassTransfer:
                return UserActionType.USD_CLASS_TRANSFER_SIGN_TYPES()
            case .UsdSend:
                return UserActionType.USD_SEND_SIGN_TYPES()
            case .Withdraw:
                return UserActionType.WITHDRAW_SIGN_TYPES()
            case .SpotSend:
                return UserActionType.SPOT_TRANSFER_SIGN_TYPES()
            }
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
        
        static func WITHDRAW_SIGN_TYPES() -> [Any] {
            return [
                ["name": "hyperliquidChain", "type": "string"],
                ["name": "destination", "type": "string"],
                ["name": "amount", "type": "string"],
                ["name": "time", "type": "uint64"],
            ]
        }
        
        static func SPOT_TRANSFER_SIGN_TYPES() -> [Any] {
            return [
                ["name": "hyperliquidChain", "type": "string"],
                ["name": "destination", "type": "string"],
                ["name": "token", "type": "string"],
                ["name": "amount", "type": "string"],
                ["name": "time", "type": "uint64"],
            ]
        }
    }
}
