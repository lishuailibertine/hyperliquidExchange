//
//  ExchangeBaseAction.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/7/25.
//
import Foundation
public protocol ExchangeBaseAction: ExchangeEncodePayload, Encodable{
    var type: String { get }
}
extension ExchangeEncodePayload where Self: Encodable {
    public func payload() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = object as? [String: Any] else {
            throw NSError(domain: "Invalid action object", code: 0, userInfo: nil)
        }
        return normalizeJSON(dict) as? [String: Any] ?? dict
    }
    
    private func normalizeJSON(_ json: Any) -> Any {
        if let dict = json as? [String: Any] {
            return dict.mapValues { normalizeJSON($0) }
        } else if let array = json as? [Any] {
            return array.map { normalizeJSON($0) }
        } else if let num = json as? NSNumber {
            let cfType = CFNumberGetType(num)
            if cfType == .charType {
                return num.boolValue
            }
            return num
        } else {
            return json
        }
    }
}
