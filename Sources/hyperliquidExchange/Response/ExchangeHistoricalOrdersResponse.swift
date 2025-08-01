//
//  ExchangeHistoricalOrdersResponse.swift
//  hyperliquidExchange
//
//  Created by li shuai on 2025/8/1.
//
import Foundation
public struct ExchangeHistoricalOrderModel: Decodable {
    public var coin: String
    public var side: String
    public var limitPx: String
    public var sz: String
    public var oid: Int
    public var timestamp: Int
    public var triggerCondition: String
    public var isTrigger: Bool
    public var triggerPx: String
    public var isPositionTpsl: Bool
    public var reduceOnly: Bool
    public var orderType: String
    public var origSz: String
    public var tif: String
}

public enum ExchangeHistoricalOrdersStatus: Decodable, Equatable {
    case filled
    case open
    case canceled
    case triggered
    case rejected
    case marginCanceled
    case unknown(String)
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        switch raw {
        case "filled":
            self = .filled
        case "open":
            self = .open
        case "canceled":
            self = .canceled
        case "triggered":
            self = .triggered
        case "rejected":
            self = .rejected
        case "marginCanceled":
            self = .marginCanceled
        default:
            self = .unknown(raw)
        }
    }
}

public struct ExchangeHistoricalOrdersResponse: Decodable {
    public var order: ExchangeHistoricalOrderModel
    public var status: ExchangeHistoricalOrdersStatus
    public var statusTimestamp: Int
}
