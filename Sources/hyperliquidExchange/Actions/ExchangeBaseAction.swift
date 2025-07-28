//
//  ExchangeBaseAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/25.
//
import Foundation
public protocol ExchangeBaseAction: ExchangeEncodePayload{
    var type: String { get }
}
extension ExchangeEncodePayload where Self: Encodable {
    public func payload() throws -> [String : Any] {
        let data = try JSONEncoder().encode(self)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = object as? [String: Any] else {
            throw NSError(domain: "Invalid ation object", code: 0, userInfo: nil)
        }
        return dict
    }
}
