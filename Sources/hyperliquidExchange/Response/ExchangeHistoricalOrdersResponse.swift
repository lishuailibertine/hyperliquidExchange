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
    case filled // 订单已完全成交
    case open // 订单已创建，但尚未成交或未全部成交
    case canceled // 订单被用户或系统取消，未全部成交
    case triggered // 条件订单已触发，但未必成交
    case rejected // 下单失败，未被接受
    case marginCanceled //爆仓?
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
